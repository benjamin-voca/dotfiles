#![allow(special_module_name)]
use chrono::{Datelike, Local};
mod lib;

#[tokio::main]
async fn main() {
    //INITIAL DECLARATIONS
    let local_date = Local::now();

    let mut month = local_date.month();
    let mut year = local_date.year();
    let mut next_month = if month == 12 { 1 } else { month + 1 };
    let mut next_year = if month == 12 { year + 1 } else { year };
    let city = "Tirana";
    let country = "Albania";
    let method = 16;

    //TODO BUILD CACHE
    //GET JSON
    let mut json = lib::json_parse(lib::reqw_json(year, month, city, country, method).await)
        .await
        .data;
    json.extend(
        lib::json_parse(lib::reqw_json(next_year, next_month, city, country, method).await)
            .await
            .data,
    );

    //-d DAEMONIZE, -p POPULATE CACHE, NONE: RUN ONCE
    let args: Vec<String> = std::env::args().collect();
    if args.iter().any(|arg| arg == "-d") {
        loop {
            let day: usize = Local::now()
                .day()
                .try_into()
                .expect("Could not convert day to usize");
            lib::notify_user(&json, day, true);
            tokio::time::sleep(tokio::time::Duration::from_secs(900)).await;
        }
    } else if let Some(index) = args.iter().position(|arg| arg == "-p") {
        if let Some(bound) = args.get(index + 1) {
            if let Ok(bound) = bound.parse::<usize>() {
                for _ in 0..bound {
                    month += 2;
                    if month > 12 {
                        month -= 12;
                        year += 1;
                    }
                    next_month = if month == 12 { 1 } else { month + 1 };
                    next_year = if month == 12 { year + 1 } else { year };

                    let _ = lib::reqw_json(year, month, city, country, method).await;

                    let _ = lib::reqw_json(next_year, next_month, city, country, method).await;
                }
            } else {
                eprintln!("Invalid argument after -p");
            }
        } else {
            eprintln!("No argument provided after -p");
        }
    } else {
        let day: usize = Local::now()
            .day()
            .try_into()
            .expect("Could not convert day to usize");
        lib::notify_user(&json, day, false);
    }
}
