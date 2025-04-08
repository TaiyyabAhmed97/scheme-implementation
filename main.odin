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
	start: int
}

tokenizer := Tokenizer{nil, 0,1,0}
tokens: [dynamic]Token

run :: proc() {
	using tokenizer
	
	// tokens := scan_tokens(source)
	for !is_at_end() {
		char := advance()
		fmt.printfln("currently scanning %c %d, \nstart: %d",source[current],current, start)
		switch char {
		  case '(': add_token(.LEFT_PAREN);
	      case ')': add_token(.RIGHT_PAREN);
	      case '{': add_token(.LEFT_BRACE);
	      case '}': add_token(.RIGHT_BRACE);
	      case ',': add_token(.COMMA);
	      case '.': add_token(.DOT);
	      case '-': add_token(.MINUS);
	      case '+': add_token(.PLUS);
	      case ';': add_token(.SEMICOLON);
	      case '*': add_token(.STAR); 
	      case '!': add_token(match('=') ? .BANG_EQUAL : .BANG);
	      case '=': add_token(match('=') ? .EQUAL_EQUAL : .EQUAL);
	      case '<': add_token(match('=') ? .LESS_EQUAL : .LESS);
	      case '>': add_token(match('=') ? .GREATER_EQUAL : .GREATER);
	      case ' ', '\r', '\t': {
	      	//ignore
	      	fmt.println("ingonred")
	      }
	      case '/': {
	      	if match('/') {
	      		peek()
	      	} else {
	      		add_token(.SLASH)
	      	}
	      }
		  case '\n': {
		  	fmt.println("new lineds")
		  	line += 1
		  }

		}
		tokenizer.current += 1
		start = current
	}
	
	fmt.println("tokens list: ", tokens)
}

add_token :: proc{
	add_token_without_literal,
	add_token_with_literal
}

add_token_with_literal :: proc(token_type: TokenType, literal: any) {
	using tokenizer
	range_start: int
	range_end: int
	if(current == start) {
		range_start = current
		range_end = current + 1
	} else {
		range_start, range_end = start, current
	}
	token := Token{token_type, tokenizer.source[range_start:range_end], literal, tokenizer.line}
	fmt.printfln("adding token when current is %d %c and start is %d %c\nSCANNED: %s", current, source[current], start, source[start],tokenizer.source[tokenizer.start:tokenizer.current])
	append(&tokens, token)
	start = current
	tokenizer.current += 1
}

peek :: proc() {
	for !is_at_end() && tokenizer.source[tokenizer.current + 1] != '\n' {
		fmt.println("PEEKING")
		tokenizer.current += 1
	}
}

match :: proc(expected: u8) -> bool {
	using tokenizer
	fmt.printfln("(current = %d,)in match and expected is %c, source[current+1] = %c",current, expected, source[current + 1])
	if source[current + 1] == expected {
		current += 1
		return true
	}
	return false
}

add_token_without_literal :: proc(token_type: TokenType) {
	add_token_with_literal(token_type, nil)
}

advance :: proc() -> u8 {
	char_to_be_scanned := tokenizer.source[tokenizer.current]
	return char_to_be_scanned
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
		fmt.println(string(f))
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