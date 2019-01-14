extern crate reqwest;

use reqwest::{header, Client};

fn main() {
    let token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx".to_string();
    let location = "montreal".to_string();
    let client = Client::new();
    let mut resp = client.get("https://api.github.com/search/users")
        .query(&[("q", format!("location:{}", location).as_str())])
        .header(header::AUTHORIZATION, format!("token {}", token).as_str())
        .send()
        .unwrap();

    println!("{}", resp.text().unwrap());
}
