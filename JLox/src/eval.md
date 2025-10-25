# Evaluator README (`eval.md`)

## Overview

The **evaluator** walks the AST and computes an integer result.

* **Input:** `AST` like `Add(Add(Num(12), Num(3)), Num(4))`
* **Output:** `Int` (`19`)

## API

```julia
evaluate(ast::AST) -> Int
```

## Semantics

* `Num(n)` evaluates to `n`
* `Add(x, y)` evaluates to `evaluate(x) + evaluate(y)`

## Implementation

*(Using an internal `_eval` lets you keep a single public name `evaluate` while still dispatching on node types. Add new node handlers by defining more `_eval(::YourNode)` methods.)*
