use chrono::{Duration,NaiveTime};

pub fn format_duration_as_time(delta: Duration) -> NaiveTime {
    let total_seconds = delta.num_seconds();
    let hours = total_seconds / 3600;
    let minutes = (total_seconds % 3600) / 60;
    let seconds = total_seconds % 60;

    NaiveTime::from_hms_opt(hours as u32, minutes as u32, seconds as u32)
        .expect("Could not convert timedelta to naivetime")
}
