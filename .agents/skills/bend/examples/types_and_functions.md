# Types and Functions

A typical Bend program is a set of datatypes and functions over them:

```python
import Base

type Shape is Data:
  Circle{r: U32}
  Square{s: U32}

def area(x: Shape) -> U32:
  match x:
    case Circle{+r}:
      (3 * r * r : U32)
    case Square{+s}:
      (s * s : U32)

def main() -> U32:
  area(Square{5})
```

Bend, by default, is *affine*, meaning variables must be used, at most, once.

Here, `is Data` declares that `Shape` may be copied, while `is Type` keeps it
non-copiable. The `+` annotation before a variable name allows using it more
than once, if the variable is Data-kinded.

Bend does almost no inference, meaning it requires more annotations than similar
languages. This is what allows Bend's checker to be significantly faster than
other provers, and its error messages more precise, at the expense of programs
and proofs being more verbose. When the checker can't decide the type of an
expression, just annotate it, as in `{3 : U32}`.
