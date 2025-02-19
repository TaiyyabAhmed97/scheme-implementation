package main

import "core:fmt"
import "core:os"
import "core:unicode"
import "core:unicode/utf8"

Token_Kind :: enum {
	// Literal value
	ATOM,
	// Single-character tokens.
	OPEN_PARENS,
	CLOSE_PARENS
}

Token_Value :: union {string, u8, rune}

Token :: struct {
	kind: Token_Kind,
	value: Token_Value
}

is_letter :: proc(r: rune) -> bool {
	if r < utf8.RUNE_SELF {
		switch r {
		case '_':
			return true
		case 'A'..='Z', 'a'..='z':
			return true
		}
	}
	return unicode.is_letter(r)
}
is_digit :: proc(r: rune) -> bool {
	if '0' <= r && r <= '9' {
		return true
	}
	return unicode.is_digit(r)
}

main :: proc() {
	tokens: [dynamic]Token
	f, ok := os.read_entire_file("test.txt")
	ensure(ok)
	file_contents := string(f)
	file_length := len(file_contents)
	read_index := 0
	reading_literal: bool
	literal_start_index: uint
	literla_end_index: uint
	for i := 0;i < len(file_contents); i+=1 {
		unicode_codepoint := file_contents[i]
		token: Token
		fmt.printfln("%d %c",unicode_codepoint, unicode_codepoint)
		switch unicode_codepoint {
			case '(':
				token = {.OPEN_PARENS, rune(unicode_codepoint) }
				append(&tokens, token)
			case ')':
				token = {.CLOSE_PARENS, rune(unicode_codepoint) }
				append(&tokens, token)
			case ' ', '\n':

			case 'A'..='Z', 'a'..='z', '0'..='9':
				j := i + 1
				starting_i := i
				for (j<len(file_contents) && 
					(is_letter(rune(file_contents[j])) || is_digit(rune(file_contents[j])))) {
					j += 1
				}
				token = {.ATOM, file_contents[starting_i:(j)]}
				append(&tokens, token)
				i = j-1
			case:
				fmt.printfln("%d %c",unicode_codepoint, unicode_codepoint)
		}
	}
	fmt.println(tokens)
}