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

  //Comments
  LINE_COMMENT,

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
		fmt.printfln("current %d %c, start %d %c, scanning: %s len(source)", current, source[current], start, source[start], source[start:current], len(source))
		char := advance()
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
	      }
	      case '"': {
	      	peek('"', .STRING)
	      	fmt.printfln("scnanning %c", source[current])
	      	start = current
	      }
	      case '/': {
	      	if match('/') {
	      		peek('\n', .LINE_COMMENT)
	      		current += 2
	      		start = current
	      		continue
	      	} else {
	      		add_token(.SLASH)
	      	}
	      }
		  case '\n': {
		  	line += 1
		  }
		  case : {
		  	if (is_letter(char)) {
		  		keyword()
				start = current
				continue
		  	}
		  }

		}
		tokenizer.current += 1
		start = current
		fmt.println(tokens)
	}
	
	for token in tokens {
		print_token(token)
	}
}

is_letter :: proc(char: u8) -> bool {
	return char >= 'A' && char <= 'z'
}

is_digit :: proc(char: u8) -> bool {
	return char >= '0' && char <= '9'
}

is_alpha :: proc(char: u8) -> bool {
	return is_digit(char) || is_letter(char)
}

keyword :: proc() {
	using tokenizer
	for !is_at_end() && is_letter(tokenizer.source[tokenizer.current]) {
		tokenizer.current += 1
	}
	add_token(.IDENTIFIER, source[start:current])
}

add_token :: proc{
	add_token_without_literal,
	add_token_with_literal
}

print_token :: proc(using token: Token) {
	fmt.printfln("Type: %s\tLexeme: %s\tLiteral: %s\tLine: %d",type, lexeme, literal, line)
}

add_token_with_literal :: proc(token_type: TokenType, literal: []u8) {
	using tokenizer
	
	range_start: int
	range_end: int
	if(current == start) {
		range_start = current
		range_end = current + 1
	} else if(token_type == .STRING) {
		range_start, range_end = start, current + 2
	}
	else {
		range_start, range_end = start, current
	}
	token := Token{token_type, tokenizer.source[range_start:range_end], literal, tokenizer.line}

	append(&tokens, token)
}

peek :: proc(lookahead: u8, token_type: TokenType) {
	using tokenizer
	for !is_at_end() && tokenizer.source[tokenizer.current + 1] != lookahead {
		tokenizer.current += 1
	}
	if(token_type == .LINE_COMMENT){ 
		add_token(token_type, tokenizer.source[tokenizer.start+2:tokenizer.current])
		line += 1
	}
	if(token_type == .STRING) {
		tokenizer.current += 1
		add_token(token_type, tokenizer.source[tokenizer.start+1:tokenizer.current+1])
		fmt.println("in here")
	 }
}

match :: proc(expected: u8) -> bool {
	using tokenizer
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