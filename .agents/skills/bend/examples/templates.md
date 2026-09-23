# Templates

A template receives its argument as syntax and inlines it at compile time.

```python
import Base

# ~f: substituted at compile time, not passed at runtime
def twice(~f: U32 -> U32, x: U32) -> U32:
  f(f(x))

def main() -> U32:
  twice(~(x => (x + 1 : U32)), 40)
```

Template parameters come first in the parameter list, and a `~` argument must
be closed: it may mention top-level defs, but no local variable of the caller.
Each distinct set of `~` arguments compiles to its own copy of `twice`, so `f`
costs nothing at runtime and, unlike a closure, may be called as many times as
you like. A template may call only templates declared above it. This is how
`List.map` is written in Base.
