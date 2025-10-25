# julialox

Dev repl

```
julia> using Pkg
julia> Pkg.activate("my-repo/TinyPlusLang")
julia> Pkg.instantiate()
julia> using TinyPlusLang
julia> evaluate(parse_string("12 + 3 + 4"))
19
```

Run tests

```
julia> using Pkg
julia> Pkg.activate("my-repo/TinyPlusLang")
julia> Pkg.test()
```
