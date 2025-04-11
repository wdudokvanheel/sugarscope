use std::sync::Arc;
use crate::database::{save_measurement, InfluxConnection};
use anyhow::{anyhow, Context, Result};
use chrono::{DateTime, FixedOffset, NaiveDateTime, TimeZone, Utc};
use librelink_client::client::{Credentials, LibreLinkClient};
use crate::measurement::GlucoseMeasurement;

pub struct LibreLinkSyncRuntime {
    influxdb: Arc<InfluxConnection>,
    libre_link: LibreLinkClient,
    last_date: Option<DateTime<Utc>>,
}

impl LibreLinkSyncRuntime {
    pub fn new(influxdb: Arc<InfluxConnection>, libre_link: LibreLinkClient) -> LibreLinkSyncRuntime {
        Self {
            influxdb,
            libre_link,
            last_date: None,
        }
    }

    pub async fn start(&mut self) {
        log::trace!("Starting librelink sync runtime");

        loop {
            let measurement = get_latest_measurement(&self.libre_link).await;
            match measurement {
                Ok(measurement) =>{
                    if self
                        .last_date
                        .clone()
                        .map(|ld| !ld.eq(&measurement.time))
                        .unwrap_or(true)
                    {
                        match save_measurement(&self.influxdb, &measurement).await {
                            Err(e) => {
                                log::error!("Failed to save measurement to influxdb: {}", e);
                            }
                            Ok(_) => {
                                log::debug!(
                                "Saved {} @ {} to influxdb",
                                &measurement.value,
                                &measurement.time
                            );
                                self.last_date = Some(measurement.time);
                            }
                        }
                    } else {
                        log::trace!(
                        "Skipping measurement @ {} because it was not updated ({:?})",
                        measurement.time,
                        self.last_date
                    );
                    }
                }
                Err(err) => {
                    log::error!("Failed to get measurement from librelink: {}", err);
                }
            }

            tokio::time::sleep(tokio::time::Duration::from_secs(30)).await;
        }
    }
}

pub async fn get_latest_measurement(client: &LibreLinkClient) -> Result<GlucoseMeasurement> {
    log::trace!("Fetching latest measurement");

    let connections = client
        .get_connections()
        .await
        .map_err(|e| anyhow!(e.to_string()))
        .context("Failed to get connections")?;

    if let Some(conn) = connections.data.first() {
        let naive_datetime = NaiveDateTime::parse_from_str(
            &*conn.glucose_measurement.factory_timestamp,
            "%m/%d/%Y %I:%M:%S %p",
        )?;
        let datetime_utc: DateTime<Utc> = Utc.from_utc_datetime(&naive_datetime);
        return Ok(GlucoseMeasurement {
            time: datetime_utc.fixed_offset().to_utc(),
            value: round_value(conn.glucose_measurement.value, 2),
        });
    }

    Err(anyhow!("No glucose measurement found"))
}

fn round_value(value: f32, decimal_places: u32) -> f64 {
    let value = value as f64;
    let factor = 10f64.powi(decimal_places as i32);
    (value * factor).round() / factor
}

#[tokio::test]
async fn test_get_latest_measurement() {
    let client = LibreLinkClient::new(
        Credentials {
            username: "".to_string(),
            password: "".to_string(),
        },
        Some("".to_string()),
    )
    .await
    .expect("Failed to authenticate");

    let bg = get_latest_measurement(&client).await;
    assert!(bg.is_ok());
    let bg = bg.unwrap();
    assert!(bg.value > 0.0);
    println!("Got a value of {} @ {}", bg.value, bg.time);
}
