package main

Token :: struct {
	type: TokenType,
	lexeme: []u8,
	literal: any,
	line: uint
}

create_token :: proc(type: TokenType, lexeme: []u8, literal: any, line: uint) -> Token {
	return Token{type, lexeme, literal, line}
}