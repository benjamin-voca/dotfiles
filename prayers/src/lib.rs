#![allow(non_snake_case)]
#![allow(dead_code)]
#![allow(non_camel_case_types)]

use chrono::{Duration, Local, NaiveTime, TimeDelta};
use notify_rust::Notification;
use serde::Deserialize;
use tokio::io::AsyncReadExt;

pub fn format_duration_as_time(delta: Duration) -> NaiveTime {
    let total_seconds = delta.num_seconds();
    let hours = total_seconds / 3600;
    let minutes = (total_seconds % 3600) / 60;
    let seconds = total_seconds % 60;

    NaiveTime::from_hms_opt(hours as u32, minutes as u32, seconds as u32)
        .expect("Could not convert timedelta to naivetime")
}

impl Timings {
    pub fn next_prayer(
        &self,
        current_time: NaiveTime,
        discriminant: bool,
    ) -> Result<(&str, TimeDelta), ()> {
        if current_time < self.Fajr {
            Ok(("Fajr", self.Fajr - current_time))
        } else if current_time < self.Dhuhr {
            Ok(("Dhuhr", self.Dhuhr - current_time))
        } else if current_time < self.Asr {
            Ok(("Asr", self.Asr - current_time))
        } else if current_time < self.Maghrib {
            Ok(("Maghrib", self.Maghrib - current_time))
        } else if current_time < self.Isha {
            Ok(("Isha", self.Isha - current_time))
        } else {
            // If current time is after Isha, return the next day's Fajr
            if discriminant {
                Ok(("Fajr", self.Fajr - current_time + Duration::try_days(1).unwrap()))
            } else {
                Err(())
            }
        }
    }
}

#[derive(Debug, Deserialize, PartialEq)]
pub struct Timings {
    #[serde(deserialize_with = "deserialize_time")]
    pub Fajr: NaiveTime,
    #[serde(deserialize_with = "deserialize_time")]
    pub Dhuhr: NaiveTime,
    #[serde(deserialize_with = "deserialize_time")]
    pub Asr: NaiveTime,
    #[serde(deserialize_with = "deserialize_time")]
    pub Maghrib: NaiveTime,
    #[serde(deserialize_with = "deserialize_time")]
    pub Isha: NaiveTime,
}

pub fn deserialize_time<'de, D>(deserializer: D) -> Result<NaiveTime, D::Error>
where
    D: serde::Deserializer<'de>,
{
    let s: &str = serde::Deserialize::deserialize(deserializer)?;
    NaiveTime::parse_from_str(&s.splitn(2, ' ').next().unwrap(), "%H:%M")
        .map_err(serde::de::Error::custom)
}

#[derive(Debug, Deserialize)]
pub struct allData {
    pub timings: Timings,
}

#[derive(Debug, Deserialize)]
pub struct ApiRequest {
    pub data: Vec<allData>,
}

async fn reqw_json_legacy(
    next_year: i32,
    next_month: u32,
    city: &str,
    country: &str,
    method: u8,
) -> reqwest::Response {
    reqwest::get(format!(
        "http://api.aladhan.com/v1/calendarByCity/{}/{}?city={}&country={}&method={}",
        next_year, next_month, city, country, method
    ))
    .await
    .expect("Could not get api info")
}
async fn json_parse_legacy(data: reqwest::Response) -> ApiRequest {
    data.json::<ApiRequest>()
        .await
        .expect("Could not deserialize")
}

pub fn notify_user(json: &Vec<allData>, day: usize, discriminant: bool) {
    let next_prayer = match json[day].timings.next_prayer(Local::now().time(), false) {
        Ok((prayer, time)) => (prayer, time),
        Err(()) => json[day + 1]
            .timings
            .next_prayer(Local::now().time(), true)
            .expect("Cannot get T-Fajr"),
    };
    if discriminant && next_prayer.1 > Duration::try_seconds(3600.into()).unwrap() {
        return;
    }
    let _ = Notification::new()
        .summary(format!("{} ", &next_prayer.0).as_str())
        .body(format!("{}", format_duration_as_time(next_prayer.1)).as_str())
        .icon(format!("/home/benjamin/.config/dunst/icons/{}.png", &next_prayer.0).as_str())
        .appname("Prayer Notification")
        .timeout(6000) // this however is
        .show();
}

pub async fn reqw_json(year: i32, month: u32, city: &str, country: &str, method: u8) -> String {
    use tokio::fs::File;
    use tokio::io::AsyncWriteExt;
    let cache_dir = dirs::cache_dir().expect("No cache dir found :(").into_os_string().into_string().unwrap(); 
    let _ = tokio::fs::create_dir_all(format!("{}/api",cache_dir)).await.expect("could not create api dir inside cache dir");
    let path = format!(
        "{}/api/{}{}{}{}{}.json",
        cache_dir,year, month, city, country, method
    );
    match File::open(&path).await {
        Ok(mut file) => {
            // dbg!("Reading From File");
            let mut content = String::new();
            let _ = file.read_to_string(&mut content).await;
            content
        }

        Err(_) => {
            // dbg!("Fetching from API");
            let req = reqwest::get(format!(
                "http://api.aladhan.com/v1/calendarByCity/{}/{}?city={}&country={}&method={}",
                year, month, city, country, method
            ))
            .await
            .expect("Could not get api info")
            .text()
            .await
            .expect("could not convert to string");
            let _ = File::create(path)
                .await
                .expect("Could not create file")
                .write_all(req.as_bytes())
                .await;
            req
        }
    }
}

pub async fn json_parse(data: String) -> ApiRequest {
    serde_json::from_str::<ApiRequest>(&data).expect("Could not convert String to J'son")
}

