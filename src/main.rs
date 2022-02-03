use std::io;

type Symbol = String;
type Atom = i64;
type Expr = Symbol;
type List<T> = Vec<T>;

fn main() {
    println!("#####\nScheme Interpreter\n#####");

    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("failed to read line");

    let tokens = tokenize(input);

    for (i, v) in tokens.iter().enumerate() {
        if v == "(" {
            let newvec = parse_into_list(tokens[i+1..].to_vec());
            println!("{:?} is the tokenized input", newvec);
            break;
        }
    }


}

fn parse_into_list(input: Vec<String>) -> Vec<String> {
    let mut newvec: Vec<String> = Vec::new();

    for i in &input{
        if i != ")" {
            newvec.push(i.clone().to_string());
        }
    }

    return newvec;

}

// fn parse(tokens_list: Vec<String>) -> Expr {
// }

fn tokenize(raw_input: String) -> Vec<String> {

    let replaced = raw_input
        .replace("(", " ( ")
        .replace(")", " ) ");

    let vec: Vec<String> = replaced.split_whitespace().map(|s| s.to_string()).collect();

    //randome comment
    println!("{:?} is the tokenized input", vec);

    return vec;
}

