# running


Run ad-hoc:

```julia
julia> include("src/lexer.jl"); include("src/parser.jl"); include("src/eval.jl");
julia> include("test/test_parser.jl"); include("test/test_eval.jl");
```

Or with Pkg’s test runner:

```
] activate .
] test
```
