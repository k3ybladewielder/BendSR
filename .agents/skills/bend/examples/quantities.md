# Quantities

A quantity says how many times a variable may be used.

```python
import Base

# -A: erased (gone at runtime)
#  n: affine (used at most once)
# +x: reusable (requires A to be Data)
def replicate(-A: Data, n: Nat, +x: A) -> List<A>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      x <> replicate(A, p, x)

def main() -> List<U32>:
  replicate(U32, 3n, 7)
```

Erased variables can only appear in types and proofs: the checker sees them, the
compiler deletes them. Affine variables are the default, and dropping one is
always free. Reusable variables require `Data`: functions, arrays and IO handles
are `Type`, so they can never be copied. Note that `main` marks nothing: you
write `+` where you need the copies, and `replicate` pays for them with a
reference count at runtime. Matching a `+` value hands out `+` fields; on a
plain one, write `+r` in the pattern to make a field reusable.
