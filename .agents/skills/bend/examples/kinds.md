# Kinds

Every type has a kind, which caps how many times its values may be used.

```python
import Base

#  a: a quantity (&0, &1 or &2)
# -A: a type whose values may be used a times
def length(a, -A: Kind(a), xs: List<a, A>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case Con{h, t}:
      1n+length(a, A, t)

def main() -> Nat:
  length(&2, U32, [1, 2, 3])
```

`Type` is short for `Kind(&1)` and `Data` for `Kind(&2)`, so a `Kind(a)`
parameter accepts both: `length(&1, U32 -> U32, fs)` counts a list of closures
just as well. A bare `a` in a parameter list is short for `-a: Quant`. Base
declares `type List<a, -A: Kind(a)> is Kind(a)`, making a list exactly as
reusable as its elements: `List<U32>` is short for `List<&1, U32>`, and
`+List<U32>` for `List<&2, U32>`. A type holding two element types combines
their quantities with `a <&> b`, the smaller of the two.
