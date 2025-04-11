use chrono::serde::ts_seconds;
use chrono::{DateTime, TimeZone, Utc};
use influxdb::{InfluxDbWriteable, WriteQuery};
use serde::{Deserialize, Serialize};

#[derive(InfluxDbWriteable, Serialize, Deserialize, Debug, Clone)]
pub struct GlucoseMeasurement {
    #[serde(with = "ts_seconds")]
    pub time: DateTime<Utc>,
    pub value: f64,
}

impl GlucoseMeasurement {
    pub fn to_write_query(&self) -> WriteQuery {
        WriteQuery::new(self.time.into(), "bloodglucose").add_field("value", self.value)
    }
}

#[test]
pub fn test_json_serialization() {
    let fixed_time = Utc.with_ymd_and_hms(2025, 3, 22, 12, 0, 0).unwrap();

    let data = vec![GlucoseMeasurement {
        time: fixed_time,
        value: 5.5,
    }];

    let json = serde_json::to_string(&data).unwrap();
    assert_eq!(json, r#"[{"time":1742644800,"value":5.5}]"#);
}
