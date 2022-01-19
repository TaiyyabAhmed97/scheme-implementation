use std::io;

type Symbol = String;
type Atom = i64;

fn main() {
    println!("Hello, world!");

    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("failed to read line");

    let tokens = tokenize(input);
}

fn tokenize(raw_input: String) -> Vec<String> {

    let replaced = raw_input
        .replace("(", " ( ")
        .replace(")", " ) ");

    let vec: Vec<String> = replaced.split_whitespace().map(|s| s.to_string()).collect();

    //randome comment
    println!("{:?} is the tokenized input", vec);

    return vec;
}

