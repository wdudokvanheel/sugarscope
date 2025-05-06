use crate::database::{get_last_entries, InfluxConnection};
use serde_json::json;
use std::sync::Arc;
use warp::Filter;

pub fn start_server(connection: Arc<InfluxConnection>) {
    tokio::spawn(async move {
        log::info!("Starting server @ 0.0.0.0:9090");
        let connection_filter = warp::any().map(move || connection.clone());
        let base_path = warp::path("api").and(warp::path("s1"));

        let graph_route = base_path
            .and(warp::path("entries"))
            .and(warp::path("last"))
            .and(warp::get())
            .and(warp::query::<QueryParams>())
            .and(connection_filter)
            .and_then(handle_latest_request);

        let status_route = base_path
            .and(warp::path("status"))
            .and(warp::get())
            .map(|| warp::reply::json(&json!({ "status": "ok" })));

        let routes = graph_route
            .or(status_route)
            .with(warp::cors().allow_any_origin());

        warp::serve(routes).run(([0, 0, 0, 0], 9090)).await;
    });
}

#[derive(serde::Deserialize)]
struct QueryParams {
    hours: Option<u32>,
    window: Option<u32>,
}

async fn handle_latest_request(
    params: QueryParams,
    connection: Arc<InfluxConnection>,
) -> Result<impl warp::Reply, warp::Rejection> {
    let hours = params.hours.unwrap_or(12);
    let window = params.window.unwrap_or(5);

    match get_last_entries(&connection, hours as i32, window as i32).await {
        Ok(data) => Ok(warp::reply::json(&data)),
        Err(_) => Err(warp::reject::custom(ApiError::database_error())),
    }
}

#[derive(Debug)]
struct ApiError {
    message: &'static str,
}

impl warp::reject::Reject for ApiError {}

impl ApiError {
    fn database_error() -> Self {
        ApiError {
            message: "Database error",
        }
    }
}
