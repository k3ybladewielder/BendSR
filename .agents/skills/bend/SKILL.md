---
name: bend
description: Bend is a new programming language that combines Lean-like formal proofs with C-like speeds and CUDA-like parallelism. It gives humans an ambiguity-free language to communicate their intents to AIs, a compiler capable of mechanically checking that the AI implemented these intents to unquestionable mathematical correctness, and a compiler that runs that code fast on CPUs and GPUs.
keywords: ["formal verification", "proof checker", "bend"]
---

When using Bend:
- run `bend guide` to learn it
- use `LAWS.bend` to keep important rules
- run `bend PROOF.bend` before committing
- parallelize the code whenever possible

Rules:
- write laws for whatever should never break, and to parallelize everything you want running fast.

## Hello, World!

Bend's syntax is Python-shaped, but its semantics are closer to Haskell / Lean,
while being resource-aware like Rust (if less annoyingly). A hello world is just
a typed definition returning an IO block:

```python
import Base

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("Hello, world!")
```

To run it, install Bend (`curl -fsSL https://bend-lang.com/install.sh | sh`)
and type `bend hello.bend`.

Bend is a *pure language*, with effects denoted via a Haskell-inspired
[IO Monad](https://wiki.haskell.org/Introduction_to_IO). It comes with a list
of built-in effects for files, networking, audio, graphics, input, and more,
and the user can extend them with foreign C and JS imports; more on that later.

## Examples & Reference Summary

Below are individual guide files for each topic and reference:

- [Tooling](file:///.agents/skills/bend/examples/tooling.md)
- [Syntax Reference](file:///.agents/skills/bend/examples/syntax_reference.md)
- [Types and Functions](file:///.agents/skills/bend/examples/types_and_functions.md)
- [Closures](file:///.agents/skills/bend/examples/closures.md)
- [Recursion and Termination](file:///.agents/skills/bend/examples/recursion_and_termination.md)
- [Parallelism](file:///.agents/skills/bend/examples/parallelism.md)
- [Arrays](file:///.agents/skills/bend/examples/arrays.md)
- [Quantities](file:///.agents/skills/bend/examples/quantities.md)
- [Kinds](file:///.agents/skills/bend/examples/kinds.md)
- [Templates](file:///.agents/skills/bend/examples/templates.md)
- [Laws and Proofs](file:///.agents/skills/bend/examples/laws_and_proofs.md)
- [IO and Concurrency](file:///.agents/skills/bend/examples/io_and_concurrency.md)
- [Monads](file:///.agents/skills/bend/examples/monads.md)
- [Apps](file:///.agents/skills/bend/examples/apps.md)
- [The Base Library](file:///.agents/skills/bend/examples/base_library.md)
- [Modules](file:///.agents/skills/bend/examples/modules.md)

## Further Reading

- `demos/`: complete programs, including the game and its proof from the video.
- `bend2/base.bend`: the Base library, also printed by `bend base`.
- `paper/BendTT.pdf` and `paper/BendRT.pdf`: the type theory and the runtime.

## Extra

`bend guide shaders` prints "Shaders in Bend", a tutorial written by AIs for
AIs on how to write efficient shaders in Bend. It distills what building
`demos/app_slash_boss_3d` (120 FPS in pure Bend) taught. Read it before you
write a graphical or parallel app in Bend.

`bend guide effects` prints "Effects in Bend", an AI-written note (to be
revised by a human) on the C and JS side of custom effects. Read it before
you write one.