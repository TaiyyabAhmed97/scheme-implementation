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

main :: proc() {
	fmt.println(os.args)
	if (len(os.args) == 2) {
		fmt.println("jlox [script]")
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
			fmt.printf("Outputted text(string): %s, bytes: %d\n", str, buf[:n])
		}
	}

	  
}