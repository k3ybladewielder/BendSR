# Recursion and Termination

Bend uses recursion to repeat work. Tail calls compile to loops.

```python
import Base

def sum(xs: List<U32>, acc: U32) -> U32:
  match xs:
    case Nil{}:
      acc
    case Con{h, t}:
      sum(t, (acc + h : U32))

def main() -> U32:
  sum([1, 2, 3, 4], 0)
```

Here, `t` has one fewer element than `xs`, so `sum` eventually reaches the empty
list. Bend verifies termination by requiring recursive calls to use smaller
parts of their inputs, obtained through pattern matching. The check reads the
arguments of a recursive call from left to right: each must be passed unchanged
until one is a smaller part of its parameter, and the ones after it are free.
So, put the parameter that shrinks first. Also, is no `if` syntax yet. Use
`match` on `True{}` and `False{}` instead.

Termination is mandatory and mutual recursion is not allowed. Both restrictions
keep Bend's proofs sound, as a function that never returns could otherwise prove
anything. A loop bounded by the outside world, like a server's, counts down a
`Nat` fuel argument instead, and two mutually recursive functions become one def
with an extra argument selecting which to run. A `def` marked `@unsafe` recurses
freely, but falls outside Bend's proof guarantees.

A `match` inspects a parameter or a variable bound by a pattern, never a
computed value: `match sum(xs, 0):` is rejected. Scrutinees follow binder order,
and a `let` may not precede a `match` on a parameter. To match on a computed
value, pass it to a helper that matches on its parameter.
