# Syntax Reference

Every form of the language, grouped by where it appears. Operators, literals
and brackets are sugar for names in Base.

```python
# Top level
import Base                              # the prelude
import ./file.bend as M                  # a module; its defs are M.x
type D<a, -A: Kind(a)> is Kind(a):       # a datatype and its kind
  K{x: A, xs: List<a, A>}                # one constructor per line
def f(x: A, -y: B, +z: C) -> T:          # a def; the body follows
def f(x, y):                             # fills the law named f
def t(~g: A -> B, x: A) -> B:            # a template
law f:                                   # a claim, proven by def f
  for x: A                               # a parameter (also for -x, for +x)
  for y: B where P(y)                    # y is then the pair (y, P(y) proof)
  exs z: C                               # a witness the proof must return
  T                                      # the claim
@unsafe def f(x: A) -> T:                # skips the termination check
def e(x: A) -> IO(B):                    # a foreign effect
  import "./e.c"
  import "./e.js"
```

```python
# Types
Type  Data  Kind(q)                      # kinds; Type = Kind(&1), Data = Kind(&2)
Quant  &0  &1  &2  a <&> b               # quantities and their minimum
A -> B  @x:A -> B  @-x:A -> B            # functions: plain, dependent, erased
A & B  &x:A -> B  A | B                  # pairs, dependent pairs, sums
D<A>  +D<A>  D<&2, A>                    # a datatype; + makes it reusable
{a == b : T}  {a != b : T}               # equality and its negation
```

```python
# Terms
42  1.5  3n  'c'  "s"                    # U32, F32, Nat, Char, String
[a, b]  h <> t  (a, b)                   # a list, a cons, a tuple
K{a, b}  x => e  +x => e                 # a constructor, a lambda
f(a, b)  f!(a)  t(~g, a)                 # a call, on the GPU, of a template
(a + b * c : T)  {x : T}                 # operators over T; an annotation
[v : T*n]  [v : T^d]  a[i]  a[i] <- v    # an array of n or 2^d slots; a read, a write
{==}  %e : P; e2  %e@E : P; e2           # reflexivity, a rewrite, a named one
?name  ?TODO                             # print the goal; leave it open
```

```python
# Statements (a def, case, lambda or parenthesized body)
x = v  +x = v  -x = v                    # a let: affine, reusable, erased
(a, b) = v  K{x, y} = v                  # a destructuring let
a b = f(x) g(y)                          # a parallel let
match a b:                               # a match on one or more values
  case K{x, _} 1n+p:                     # patterns nest; _ catches the rest
do M<xs.., R>:                           # a monadic block over M.bind, M.pure
  x : A <- m                             # bind
  x : A = v                              # let
  m                                      # a Unit step
  return v                               # the result
```

Inside `(.. : T)`, `+ - * / %` call `T.add` through `T.mod`, `.&. .|. .^.` the
bit operations, `<< >>` the shifts (by a `Nat`), and `< <= > >=` the `T.is_lt`
family; without a `: T` they belong to `Nat`. `&& ||` work on `Bool` and `++` on
`String` anywhere. Operators need spaces on both sides.
Equality of values is a call, `T.is_eq(a, b)`; `==` is only the type.
A `Nat` literal past `256n` is `U32.to_nat(n)` underneath, up to `4294967295n`.
