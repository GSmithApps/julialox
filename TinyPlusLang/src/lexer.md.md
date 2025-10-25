# Lexer overview

This tiny lexer tokenizes an ultra-simple language:

* **Tokens**: positive integers and the plus sign (`+`)
* **Separators**: tokens must be separated by **whitespace**
* **Goal**: convert a source string into a flat `Vector{Token}`

## Grammar (informal)

```text
Expr  := Num (WS "+" WS Num)* WS?
Num   := [0-9]+
WS    := one or more Unicode whitespace chars
```

No negatives, no decimals, no parentheses, and `+` **must** be surrounded by whitespace.

## Token types

```julia
abstract type Token end

struct NumberToken <: Token
    value::Int
end

struct PlusSign <: Token
end
```

* `NumberToken(value::Int)` holds a positive integer.
* `PlusSign()` represents the literal `+`.

## API

```julia
tokenize(src::AbstractString) -> Vector{Token}
```

Returns a vector like:

```julia
[NumberToken(12), PlusSign(), NumberToken(3), PlusSign(), NumberToken(456)]
```

### Errors

`tokenize` throws `ArgumentError` for:

* unexpected characters (anything besides digits, whitespace, or `+`)
* missing whitespace separation (e.g., `"1+2"`)

### Unicode & indexing

The implementation uses `firstindex`/`nextind`, so it’s safe on Unicode strings. Token classification still only accepts ASCII digits (`'0'`–`'9'`) and `'+'`.

### Performance note

The function is recursive for clarity. Julia doesn’t guarantee tail-call elimination; for extremely long inputs, consider a loop-based rewrite.

## Tests

I have some tests in sketch-test.jl, but I should probably save them as as `runtests.jl` or include under `test/` if you’re using Pkg’s test runner.
These tests avoid defining `==` for tokens by comparing a simplified tuple view.

### Running

* Quick ad-hoc run:

  ```julia
  julia> include("lexer.jl"); include("runtests.jl")
  ```

* With Pkg test layout:

  ```text
  Project
  ├─ src/lexer.jl
  └─ test/runtests.jl
  ```

  then:

  ```julia
  ] test
  ```
