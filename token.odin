package main

Token :: struct {
	type: TokenType,
	lexeme: string,
	literal: any,
	line: uint
}

create