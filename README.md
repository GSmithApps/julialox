# julialox

Dev repl

```julia
using Pkg
Pkg.activate("my-repo/TinyPlusLang")
Pkg.instantiate()
using TinyPlusLang
evaluate(parse_string("12 + 3 + 4"))
```

```text
19
```

Run tests

```julia
using Pkg
Pkg.activate("my-repo/TinyPlusLang")
Pkg.test()
```

Run ad-hoc:

```julia
include("src/lexer.jl")
include("src/parser.jl")
include("src/eval.jl")
include("test/test_lexer.jl")
include("test/test_parser.jl")
include("test/test_eval.jl")
```

Or with Pkg’s test runner:

```
] activate .
] test
```

### Running

* Quick ad-hoc run:

  ```julia
  julia> include("lexer.jl"); include("runtests.jl")
  ```

* With Pkg test layout:


  ```julia
  ] test
  ```

