package main
import "core:fmt"
import "core:os"

TokenType :: enum {
	// Single-character tokens.
  LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE,
  COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR,

  // One or two character tokens.
  BANG, BANG_EQUAL,
  EQUAL, EQUAL_EQUAL,
  GREATER, GREATER_EQUAL,
  LESS, LESS_EQUAL,

  // Literals.
  IDENTIFIER, STRING, NUMBER,

  // Keywords.
  AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
  PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,

  EOF
}

Tokenizer :: struct {
	source: []u8,
	current: int,
	line: uint,
	start: uint
}

tokenizer := Tokenizer{nil, 0,0,0}
tokens: [dynamic]Token

run :: proc() {
	
	// tokens := scan_tokens(source)
	fmt.println("running!!!", tokenizer.source)
	char := advance()
	tokenizer.current += 1
	switch char {
	  case '(': add_token(.LEFT_PAREN); break;
      case ')': add_token(.RIGHT_PAREN); break;
      case '{': add_token(.LEFT_BRACE); break;
      case '}': add_token(.RIGHT_BRACE); break;
      case ',': add_token(.COMMA); break;
      case '.': add_token(.DOT); break;
      case '-': add_token(.MINUS); break;
      case '+': add_token(.PLUS); break;
      case ';': add_token(.SEMICOLON); break;
      case '*': add_token(.STAR); break; 
	}
	fmt.println("tokens list: ", tokens)
}



add_token :: proc{
	add_token_without_literal,
	add_token_with_literal
}

add_token_with_literal :: proc(token_type: TokenType, literal: any) {
	fmt.println(tokenizer)
	token := Token{token_type, tokenizer.source[tokenizer.start:tokenizer.current], literal, tokenizer.line}
	append(&tokens, token)
}

add_token_without_literal :: proc(token_type: TokenType) {
	add_token_with_literal(token_type, nil)
}

advance :: proc() -> u8 {
	return tokenizer.source[tokenizer.current]
}	

init_tokenizer :: proc(file: []u8) -> Tokenizer {
	return Tokenizer{file,-1,0,0}
} 

is_at_end :: proc() -> bool {
	return tokenizer.current >= len(tokenizer.source)
}

main :: proc() {

	fmt.println(os.args)
	if (len(os.args) == 2) {
		fmt.println("jlox [script]")
		f, ok := os.read_entire_file_from_filename(os.args[1])
		if !ok {
			fmt.println("Wah wah!")
			os.exit(1)
		}
		tokenizer.source = f
		run()
	} else if (len(os.args) > 2) {
		fmt.println("wrong usage")
	} else {
		fmt.println("jlox interactive session")
		for {
			buf: [256]byte
			fmt.print(">")
			n, err := os.read(os.stdin, buf[:])
			if err != nil {
				fmt.eprintln("Error reading: ", err)
				return
			}
			if n == 0 {
				fmt.println("recived nothing!!")
				break
			}
			str := string(buf[:n])
			tokenizer.source = buf[:n]
			run()
			fmt.printf("Outputted text(string): %s, bytes: %d\n", str, buf[:n])
		}
	}

	  
}