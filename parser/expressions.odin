package parser

NumberExpr :: struct {
	Value: f64
}
SymbolExpr :: struct {
	Value: f64
}
StringExpr :: struct {
	Value: f64
}

expr_number :: proc(n_expr: NumberExpr) {}
expr_string :: proc(n_expr: StringExpr) {}
expr_symbol :: proc(n_expr: SymbolExpr) {}

// Complex expresions

BinaryExpr :: struct {
	Left: Expr
	Operator: Token
	Right: Expr
}

expr_binary :: proc(n_expr: BinaryExpr) {}

expr :: proc{
	expr_number,
	expr_string,
	expr_binary,
	expr_symbol
}

Parser :: struct {
	tokens: []Token
	position: int
}

parse :: proc() {
	
}
