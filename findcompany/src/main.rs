extern crate reqwest;
extern crate json;

use reqwest::{header, Client, Url};

fn main() {
    let token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    let location = "montreal";
    let client = Client::new();
    let mut resp = client.get("https://api.github.com/search/users")
        .query(&[("q", format!("location:{}", location).as_str())])
        .header(header::AUTHORIZATION, format!("token {}", token).as_str())
        .send()
        .unwrap();

    let j = json::parse(resp.text().unwrap().as_str()).unwrap();

    if !j.has_key("items") {
        panic!("Request failed. Errors:\n{}", j.pretty(2));
    }

    let total_count = &j["total_count"];
    let incomplete = &j["incomplete_results"];
    println!("count={} incomplete={}", total_count, incomplete);

    for user in j["items"].members() {
        let url = Url::parse("https://api.github.com/users/")
            .unwrap()
            .join(&user["login"].as_str().unwrap())
            .unwrap();
        let mut r = client.get(url)
            .header(header::AUTHORIZATION, format!("token {}", token).as_str())
            .send()
            .unwrap();
        let u = json::parse(r.text().unwrap().as_str()).unwrap();
        u.pretty(2);
        if u.has_key("company") {
            let company = &u["company"];
            if !company.is_null() {
                println!("{}", company)
            }
        }
    }
}
