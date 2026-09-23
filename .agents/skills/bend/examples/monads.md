# Monads

The `do` notation works for any monad, not just IO.

```python
import Base

def add_strs(a: String, b: String) -> Maybe<&2, U32>:
  do Maybe<&2, U32>:
    x : U32 <- U32.read(a) # a None here ends the block with None
    y : U32 <- U32.read(b)
    return (x + y : U32)

def main() -> Maybe<&2, U32>:
  add_strs("40", "2")
```

A `do M<xs.., R>:` block desugars each `x : A <- v` into `M.bind(xs.., A, R, v,
x => ..)` and each `return e` into `M.pure(xs.., R, e)`, so any type with those
two defs works: `IO`, `Maybe`, `Result`, or your own. The leading arguments
(here, the `&2` quantity) are passed along to both.
