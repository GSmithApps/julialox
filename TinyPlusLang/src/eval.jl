# eval.jl

evaluate(a::AST) = _eval(a)

_eval(n::Num) = n.value
_eval(a::Add) = _eval(a.left) + _eval(a.right)