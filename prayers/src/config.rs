use clap::*;
#[derive(ValueEnum, Clone, Copy)]
pub enum Action {
    Run,
    Daemonize,
    Populatem,
}

#[derive(Parser, Clone)]
#[command(version, about, long_about = None)]
pub struct Config {
    pub month: u32,
    pub year: i32,
    pub next_month: u32,
    pub next_year: i32,
    pub city: String,
    pub country: String,
    pub method: u8,
    pub action: Action,
}
impl Config {
    pub fn new(
        month: u32,
        year: i32,
        next_month: u32,
        next_year: i32,
        city: String,
        country: String,
        method: u8,
        action: Action,
    ) -> Config {
        Config {
            month,
            year,
            next_month,
            next_year,
            city,
            country,
            method,
            action,
        }
    }
}
