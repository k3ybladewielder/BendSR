# Laws and Proofs

A law states a fact that must hold. It must be proven inside a paired def.

```python
import Base

# LAW: "for every x, x plus 0 equals x"
law add_zero:
  for x: Nat
  {Nat.add(x, 0n) == x : Nat}

# PROOF: case analysis:
# - base case: reflexivity
# - step case: induction, rewrite, reflexivity
def add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}

def main() -> {Nat.add(2n, 0n) == 2n : Nat}:
  add_zero(2n)
```

Laws are a critical feature in Bend, as they provide an ambiguity-free language
on which humans can state precise specs for AI's to implement. That is, instead
of writing a natural language prompt such as "implement a function that sorts a
list", users can write precise laws like "implement a function F such that, for
every list of numbers, `F(list)` returns the same numbers in ascending order".
Models are then guaranteed to respond with bug-free code, since Bend will demand
that they provide an actual proof.

> We envision that "law-driven development" will eventually become the way humans
> use AI to write and maintain large codebases, as it is the perfect middle point
> between having to code everything manually (laborious) and letting AI do it all
> via prompts without auditing a line of code (error/ambiguity-prone, unsecure).

By convention, a project keeps its laws in two files at its root. `LAWS.bend`
imports the code and states the laws, each an open claim: the human writes it,
the AI does not touch it. `PROOF.bend` imports `LAWS.bend` and proves each law
with a def of the same name (`law sorted` is proven by `def Laws.sorted`): the
AI writes it, along with the code. `bend PROOF.bend` is the gate: it fails while
any law is open or false, and prints "All terms check." once every law holds.
bend refuses a `PROOF.bend` that sits beside a `LAWS.bend` without importing it.

Bend has no tactics: a proposition is a type, and a proof is a def of that type.
`{a == b : T}` is an equality; `{==}` proves it when both sides compute to the
same term. Matching refines the goal in each case, a recursive call is the
induction hypothesis, and `%e : P` rewrites with `e : {a == b : T}`: `P` is the
goal with `_` marking `b`, and the goal becomes `P` with `a` there. `exs y: T`
in a law asks for a witness, returned as `(y, proof)`. A failed step prints the
expected and observed terms; `?name` prints the goal, `?TODO` leaves it open,
and a law with no def is an open claim.

Since types are terms, a def may return a `Type`, like `def IsEven(n: Nat) ->
Type:`, which is all dependent types are. A `match e:` with no cases closes a
branch where `e : Empty`. To refute a clash like `e : {1n == 0n : Nat}`, rewrite
it through a motive `disc(_)`, where `disc` sends `0n` to `Empty` and `1n+p` to
`Unit`, and answer `Unit{}`. `{a != b : T}` is `{a == b : T} -> Empty`, and
`Equal.sym`, `Equal.trans` and `Equal.cong` are in Base.
