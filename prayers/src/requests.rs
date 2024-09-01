use crate::config::Config;
use crate::helpers::format_duration_as_time;
use crate::timings::Timings;
use chrono::{Duration, Local};
use notify_rust::Notification;
use serde::Deserialize;
use serde_json::Deserializer;
use tokio::io::AsyncReadExt;

#[derive(Debug, Deserialize)]
pub struct allData {
    pub timings: Timings,
}

#[derive(Debug, Deserialize)]
pub struct ApiRequest {
    pub data: Vec<allData>,
}

pub async fn reqw_json_legacy(
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
pub async fn json_parse_legacy(data: reqwest::Response) -> ApiRequest {
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

pub async fn reqw_json(conf: Config) -> String {
    use tokio::fs::File;
    use tokio::io::AsyncWriteExt;

    let Config {
        year,
        month,
        city,
        country,
        method,
        next_month,
        next_year,
        action,
    } = conf;
    let cache_dir = dirs::cache_dir()
        .expect("No cache dir found :(")
        .into_os_string()
        .into_string()
        .unwrap();
    let _ = tokio::fs::create_dir_all(format!("{}/api", cache_dir))
        .await
        .expect("could not create api dir inside cache dir");
    let path = format!(
        "{}/api/{}{}{}{}{}.json",
        cache_dir, year, month, city, country, method
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
