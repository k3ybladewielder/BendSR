# The Base Library

Base is small, and its names follow a scheme, so you can guess most of it:

```python
import Base

def main() -> String:
  +a = (6 * 7 : U32)         # sugar for U32.mul(6, 7)
  b  = U32.to_nat(a)         # conversions are T.to_x and T.from_x
  U32.show(a) ++ " = " ++ Nat.show(b)
```

Every def is named `Type.verb`, and the same verbs recur across `Nat`, `U32`
and `F32`: `add sub mul div mod` for arithmetic, `and or xor not shl shr` for
bits (`U32` only), `cmp` (returning `Cmp`, not on `F32`) and `is_eq is_ne is_lt
is_le is_gt is_ge` (returning `Bool`) for comparisons, `show` to `String` and
`read` back from it (answering a `Maybe`). Operators and `<`-style comparisons
are just sugar for these. Beyond numbers there are `Bool`, `Cmp`, `Maybe`,
`Result`, `List`, `Array`, a string-keyed `Map` (`new set get has del keys`;
`get` takes a default, and `get` and `has` hand the map back beside their
result), `Set` on top of it, the `Equal` lemmas, and the effects. `bend base`
prints all of it, `bend base --types` only the types, and `bend base Map` one
name and everything under it.
