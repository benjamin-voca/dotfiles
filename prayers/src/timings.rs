use chrono::{NaiveTime,Duration};
use crate::*;

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
