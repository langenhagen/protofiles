// author: andreasl

// -------------------------------------------------------------------------------------------------
// Types & Variables

// bare str has no compile-time-known size (it's a Dynamically Sized Type aka "DST"),
// so it can't be a plain variable:
// let bare: str = "andreasl"; // does NOT compile -- size of str is not known at compile time

// str = string slice, unsized, always used behind a reference: &str.
// &str = a reference to string data (e.g. a literal) -- borrowed, not owned.
let s: &str = "andreasl";

// -------------------------------------------------------------------------------------------------
// Format Specifiers - {} and {:?}
// {} = Display (user-facing). {:?} = Debug (dev-facing, mechanical, quotes strings).

let my_name = "andreasl";
println!("{my_name}"); // andreasl
println!("{my_name:?}"); // "andreasl"

// -------------------------------------------------------------------------------------------------
// Enums - not Python Enums, a bit like C++ Unions though. Alternative thingos under one umbrella.
// Tagged union: a fixed set of possible shapes, each carrying its own data.

enum TrafficLight {
    Red,
    Yellow,
    Green,
}

enum Shape {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
    Point,
}

fn area(shape: &Shape) -> f64 {
    match shape {
        // match is exhaustive -- compile error if a variant is missing
        Shape::Circle { radius } => std::f64::consts::PI * radius * radius,
        Shape::Rectangle { width, height } => width * height,
        Shape::Point => 0.0,
    }
}

// -------------------------------------------------------------------------------------------------
// if let
// Checks one specific variant, ignoring the rest -- a lighter match for just one case.

let light = TrafficLight::Red;
if let TrafficLight::Red = light {
    println!("stop"); // sopt
}

// -------------------------------------------------------------------------------------------------
// Option<T> and Some(value) and None

let maybe_name: Option<&str> = Some("andreasl");
if let Some(name) = maybe_name {
    println!("{name}"); // andreasl
}

let nothing: Option<&str> = None;
if let Some(name) = nothing {
    println!("{name}"); // never runs
}

// -------------------------------------------------------------------------------------------------
// #[derive(Debug)]
// derive = auto-generate a trait impl from the type's fields.

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

println!("{:?}", Point { x: 1, y: 2 }); // Point { x: 1, y: 2 }

// -------------------------------------------------------------------------------------------------
// Closures
// |params| body -- inline anonymous function, can capture surrounding variables.

let double = |x: i32| x * 2;
println!("{}", double(21)); // 42

// -------------------------------------------------------------------------------------------------
// Error Handling (thiserror)

use thiserror::Error;

#[derive(Error, Debug)]
enum ConvertError {
    #[error("invalid value {value:?} for field {field} in {path}")]
    InvalidValue {
        field: String,
        value: String,
        path: String,
        #[source]
        source: std::num::ParseIntError,
    },
}

fn parse_age(field: &str, value: &str, path: &str) -> Result<u32, ConvertError> {
    value.parse::<u32>().map_err(|source| ConvertError::InvalidValue {
        field: field.to_string(),
        value: value.to_string(),
        path: path.to_string(),
        source,
    })
}

fn main() {
    let err = parse_age("age", "abc", "input.json").unwrap_err();
    println!("{err}"); // invalid value "abc" for field age in input.json
    println!("{err:?}"); // InvalidValue { field: "age", value: "abc", path: "input.json", source: ... }

    use std::error::Error;
    if let Some(cause) = err.source() {
        println!("caused by: {cause}"); // invalid digit found in string
    }
}
