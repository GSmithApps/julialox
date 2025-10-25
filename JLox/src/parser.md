# Parser README (`parser.md`)

## Overview

The **parser** turns a flat list of tokens from the lexer into an **Abstract Syntax Tree (AST)**.

* **Input:** `Vector{Token}` (e.g., `[NumberToken(12), PlusSign(), NumberToken(3)]`)
* **Output:** `AST` (e.g., `Add(Num(12), Num(3))`)
* **Grammar (token-level):**

  ```text
  Expr := Number ( "+" Number )*
  ```

* **Associativity:** left-associative, so `a + b + c` parses as `Add(Add(a, b), c)`.

## AST node types

```julia
abstract type AST end

struct Num <: AST
    value::Int
end

struct Add <: AST
    left::AST
    right::AST
end
```

## API

```julia
parse_tokens(tokens::Vector{Token}) -> AST
parse_string(src::AbstractString)  -> AST  # convenience: tokenize + parse
```

### Errors

`parse_tokens` / `parse_string` throw `ArgumentError` for malformed sequences:

* empty input: `""` or `Token[]`
* starts/ends with `+` (e.g., `"+ 1"`, `"1 +"`)
* repeated `+` or `+` where a number is expected (`"1 ++ 2"`, `"1 + + 2"`)
* missing `+` between numbers (`"1 2"`)
