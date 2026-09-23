# Arrays

Arrays give Bend in-place mutation without giving up purity:

```python
import Base

def main() -> Array<U32> & U32:
  a = [0 : U32*8n] # new array with 8 copies of 0
  a[5] <- 42       # performs an in-place rewrite
  a[5]             # reads index 5
```

An `Array<T>` is a `Type`, so it has exactly one owner at all times. That is
what lets `a[5] <- 42` overwrite the slot and hand back the same array, with no
copy. A read hands the array back next to the element for the same reason: if
it returned only the element, the array would be gone. Indexes wrap around. A
write followed by another statement re-binds its array: `a[5] <- 42` on its own
line is `a = a[5] <- 42`. As the last statement it is the written array. The
slot count after `*` is a power of two; `[0 : U32^3n]` names the depth instead.

The `a[i]` sugar assumes `Array<U32>`. For other element types, call
`Array.get` (`Data` elements; else `Array.swap`) and `Array.set` directly, and
`Array.clone` when you need two copies. Read Bend's Base for reference. This
will be generalized soon!
