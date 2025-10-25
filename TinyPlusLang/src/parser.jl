# parser.jl

# --- AST types ---
abstract type AST end

struct Num <: AST
    value::Int
end

struct Add <: AST
    left::AST
    right::AST
end

# --- Entry points ---
function parse_string(src::AbstractString)
    return parse_tokens(tokenize(src))
end

function parse_tokens(tokens::Vector{Token})
    isempty(tokens) && throw(ArgumentError("Empty input. Expected a number."))
    ast, i = parse_expr(tokens, 1)
    if i <= length(tokens)
        leftover = tokens[i]
        throw(ArgumentError("Unexpected token after complete expression: $(typeof(leftover))"))
    end
    return ast
end

# --- Recursive-descent ---
# Expr := Number ( "+" Number )*
function parse_expr(ts::Vector{Token}, i::Int)
    left, i = parse_primary(ts, i)
    while i <= length(ts)
        if ts[i] isa PlusSign
            i += 1
            right, i = parse_primary(ts, i)
            left = Add(left, right)  # left-associative
        else
            break
        end
    end
    return left, i
end

# Primary := Number
function parse_primary(ts::Vector{Token}, i::Int)
    i > length(ts) && throw(ArgumentError("Unexpected end of tokens; expected a number."))
    t = ts[i]
    if t isa NumberToken
        return Num(t.value), i + 1
    elseif t isa PlusSign
        throw(ArgumentError("Unexpected '+'. Expected a number."))
    else
        throw(ArgumentError("Unexpected token $(typeof(t)); expected a number."))
    end
end