use std::io;

struct Atom {
    content: String
}

fn main() {
    println!("Hello, world!");

    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("failed to read line");

    let new_atom = Atom{
        content: input[..input.len()-1].to_owned()
    };

    is_atom(new_atom)
}

fn is_atom(atom: Atom) {

    println!("{} is the input", atom.content);

   match atom.content.as_ref() {
       "hello" => println!("hello world"),
       _ => println!("anything")
   }   
}
