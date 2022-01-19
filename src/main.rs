use std::io;


fn main() {
    println!("Hello, world!");

    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("failed to read line");

    tokenize(input);
}

fn tokenize(raw_input: String){

    let replaced = raw_input
        .replace("(", " ( ")
        .replace(")", " ) ");

    let vec: Vec<String> = replaced.split_whitespace().map(|s| s.to_string()).collect();

    //randome comment
    println!("{:?} is the tokenized input", vec);
}

