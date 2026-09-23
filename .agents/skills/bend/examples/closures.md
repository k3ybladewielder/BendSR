# Closures

Functions are values and can be stored, passed, and returned from other functions.

```python
import Base

def adder(k: U32) -> U32 -> U32:
  x => (x + k : U32)

def main() -> U32:
  add2 = adder(2)
  add5 = adder(5)
  add5(add2(1))
```

A closure is affine: it can be called at most once, even when everything it
captures is `Data`. Only top-level definitions can be called freely. Partial
applications like `U32.add(2)` are closures too.
