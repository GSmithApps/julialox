abstract type Token end

struct NumberToken <: Token
    value::Int
end

struct PlusSign <: Token
end

"""
    tokenize(src::AbstractString) -> Vector{Token}

Lexes a language with only positive integers and plus signs.
All tokens must be separated by whitespace.
Raises an ArgumentError on any unexpected character.
"""
function tokenize(src::AbstractString)
    return tokenize(src, "", Token[])
end

# internal recursive form
function tokenize(remaining::AbstractString, mid::AbstractString, toks::Vector{Token})
    # end of input: flush any pending number
    if isempty(remaining)
        if !isempty(mid)
            push!(toks, NumberToken(parse(Int, mid)))
        end
        return toks
    end

    # get next character safely (handles Unicode)
    i = firstindex(remaining)
    c = remaining[i]
    j = nextind(remaining, i)
    rest = remaining[j:end]

    if isdigit(c)
        # keep building a number
        return tokenize(rest, mid * c, toks)

    elseif isempty(mid)
        # not currently building a number
        if isspace(c)
            return tokenize(rest, "", toks)
        elseif c == '+'
            push!(toks, PlusSign())
            return tokenize(rest, "", toks)
        else
            throw(ArgumentError("Unexpected character '$c' while not building a number."))
        end

    else
        # currently building a number
        if isspace(c)
            # finish the number, then reprocess the space next
            push!(toks, NumberToken(parse(Int, mid)))
            return tokenize(remaining, "", toks)
        elseif c == '+'
            # require whitespace separation
            throw(ArgumentError("Expected whitespace after number; got '+' immediately after digits."))
        else
            throw(ArgumentError("Unexpected character '$c' while building a number."))
        end
    end
end
