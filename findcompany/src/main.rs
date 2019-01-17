extern crate regex;
extern crate json;
extern crate reqwest;

use reqwest::{Client, Response, Url};
use reqwest::header::{AUTHORIZATION, LINK};
use json::JsonValue;
use regex::Regex;

const API: &str = "https://api.github.com/";

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
    fn query(&self, url: Url, params: Option<&[(&str, &str)]>) -> Response {
        let mut builder = self.client.get(url);
        if let Some(p) = params {
            builder = builder.query(p);
        }
        builder.header(AUTHORIZATION, format!("token {}", self.token).as_str()).send().unwrap()
    }

    fn users_at_location(&mut self, location: &str) -> JsonValue {
        self.cur_page += 1;

        let url = Url::parse(API).unwrap().join("search/users").unwrap();
        let resp = self.query(url, Some(&[
            ("q", format!("location:{}", location).as_str()),
            ("per_page", "100"),
            ("page", format!("{}", self.cur_page).as_str()),
        ]));

        let re = Regex::new(r#"page=(\d+)>; rel="last""#).unwrap();
        let text = resp.headers().get(LINK).unwrap().to_str().unwrap();
        let caps = re.captures(text).unwrap();
        self.total_page = caps.get(1).unwrap().as_str().parse().unwrap();
        println!("{}/{} pages", self.cur_page, self.total_page);

        let mut j = parse_json(resp);
        if !j.has_key("items") {
            panic!("Request failed. Returned JSON:\n{}", j.pretty(2));
        }
        j["items"].take()
    }

    fn user_profile(&self, username: &str) -> JsonValue {
        let url = Url::parse(API).unwrap().join("users/").unwrap().join(username).unwrap();
        parse_json(self.query(url, None))
    }
}

fn main() {
    let mut q = Q {
        client: Client::new(),
        token: "x".to_string(),
        total_page: 0,
        cur_page: 0,
    };

    loop {
        for user in q.users_at_location("montreal").members() {
            let profile = q.user_profile(user["login"].as_str().unwrap());
            let company = &profile["company"];
            if !company.is_null() {
                println!("{:-20} {:-20} {}", profile["login"], company, profile["url"]);
            }
        }

        if q.cur_page == q.total_page {
            break;
        }
    }
}
