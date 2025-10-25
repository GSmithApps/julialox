module TinyPlusLang

# public API exports
export Token, NumberToken, PlusSign
export tokenize
export AST, Num, Add
export parse_string, parse_tokens
export evaluate

# bring implementation files in
include("lexer.jl")
include("parser.jl")
include("eval.jl")

end # module
