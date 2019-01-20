extern crate regex;
extern crate json;
extern crate reqwest;

use reqwest::{Client, Response, Url};
use reqwest::header::{AUTHORIZATION, LINK};
use json::JsonValue;
use regex::Regex;
use std::env;

const API: &str = "https://api.github.com";

struct Q {
    client: Client,
    token: String,
    cur_page: usize,
    total_page: usize,
}

fn parse_json(mut resp: Response) -> JsonValue {
    json::parse(resp.text().unwrap().as_str()).unwrap()
}

impl Q {
    fn new(token: String) -> Self {
        Q {
            client: Client::new(),
            token,
            total_page: 0,
            cur_page: 1,
        }
    }

    fn query(&self, path: String, params: Option<&[(&str, &str)]>) -> Response {
        let url = format!("{}/{}", API, path);
        let url = Url::parse(url.as_str()).expect("failed to parse URL");
        let mut builder = self.client.get(url);
        if let Some(p) = params {
            builder = builder.query(p);
        }
        builder.header(AUTHORIZATION, format!("token {}", self.token).as_str())
            .send().expect("failed to send request")
    }

    fn users_at_location(&mut self, location: &str) -> JsonValue {
        let resp = self.query("search/users".to_string(),
                              Some(&[
                                  ("q", format!("location:{}", location).as_str()),
                                  ("per_page", "100"),
                                  ("page", format!("{}", self.cur_page).as_str()),
                              ]));

        let re = Regex::new(r#"page=(\d+)>; rel="last""#).expect("failed to parse regex");
        let text = resp.headers().get(LINK).expect("failed to get Link header")
            .to_str().expect("failed to get Link header string");

        if self.total_page == 0 {
            let caps = re.captures(text).expect("failed to get captures");
            self.total_page = caps.get(1).expect("failed to get capture group")
                .as_str().parse().expect("failed to parse as number");
        }

        self.cur_page += 1;

        let mut j = parse_json(resp);
        if !j.has_key("items") {
            panic!("Request failed. Returned JSON:\n{}", j.pretty(2));
        }

        j["items"].take()
    }

    fn user_profile(&self, username: &str) -> JsonValue {
        let path = format!("users/{}", username);
        parse_json(self.query(path, None))
    }
}

fn main() {
    let mut q = Q::new(env::args().nth(1).expect("no access token"));

    println!("<!DOCTYPE html>\n<html>\n<head></head>\n<body>\n");

    loop {
        println!("<table>");
        for user in q.users_at_location("montreal").members() {
            let profile = q.user_profile(user["login"].as_str().expect("failed to get username string"));
            let company = &profile["company"];
            if !company.is_null() {
                let s = company.as_str().expect("failed to get company string");
                if s.as_bytes()[0] == b'@' {
                    let (_, rest) = s.split_at(1);
                    println!("  <tr><td>{:-20}</td><td><a href=\"https://github.com/{}\">{}</a></td></tr>", profile["login"], rest, company);
                }
                else {
                    println!("  <tr><td>{:-20}</td><td>{}</td></tr>", profile["login"], company);
                }
            }
        }
        println!("</table>");
        println!("<br />");

        if q.cur_page > q.total_page {
            break;
        }
    }

    println!("</body>\n</html>");
}
