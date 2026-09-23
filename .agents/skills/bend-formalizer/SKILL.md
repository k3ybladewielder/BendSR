---
name: bend-formalizer
description: Use this skill exclusively when the user explicitly asks to use Bend to mathematically prove a project or repository and requests the rewriting of logic in Bend, the declaration of properties in LAWS.bend, and the proof in PROOF.bend. Do not use it for general explanations, Bend generation without this formal objective, or generic validation.
metadata:
  activation-condition: explicit-bend-mathematical-proof-workflow
  source: ~/.bend/
---

# Bend Skill — mathematical formalization of projects

## Mandatory activation guard

Apply this skill only when the request explicitly aims to use Bend to mathematically prove a project or repository and includes the following workflow:

1. rewrite the project's relevant logic in Bend;
2. declare properties or invariants in `LAWS.bend`;
3. prove the laws in `PROOF.bend`.

If the request merely mentions "using Bend" but does not ask for a mathematical formalization of a project/repository involving `LAWS.bend` and `PROOF.bend`, **do not use this skill**. This includes:

- general questions or explanations about Bend;
- Bend code generation without the goal of mathematical proof;
- generic code validation without an explicit request to formalize the project in Bend;
- using Bend solely as a runtime, implementation language, or parallel backend;
- attempts to directly prove arbitrary code written in Python, TypeScript, Rust, C, or other languages.

This guard must be respected even if the skill is loaded manually. If any condition is missing, respond normally without applying this skill's workflow.

## Proof objective and scope

The goal is to construct a verifiable formalization of the project's relevant behavior:

```text
original project logic
        ↓ rewrite/modeling
Bend modules and functions
        ↓ specification
LAWS.bend
        ↓ checker-based proof
PROOF.bend
```

Bend does not automatically import external implementations, nor does it directly prove Python, TypeScript, Rust, or C code. If the original project is in another language:

- select the logic and behavior that need to be formalized;
- rewrite that behavior in Bend;
- declare the properties of the formal version in `LAWS.bend`;
- prove them in `PROOF.bend`;
- explicitly state that the proof covers the Bend model.

Equivalence between the original implementation and the Bend model requires an additional demonstration of refinement or equivalence. Do not claim that the original code has been proven simply because the Bend rewrite passed the checker.

## Sources of truth

The operational and semantic source of truth is the Bend installation at `~/.bend/` — typically `~/.bend/bend` — rather than a checkout or copy of the repository in another directory.

Use exclusively the installed CLI to query the version, language, and library:

```sh
~/.bend/bend --version
~/.bend/bend guide
~/.bend/bend base
~/.bend/bend --help
```

If `~/.bend/bend` (or `bend`) does not exist or is not executable, report that the installed Bend is unavailable. If the user has already installed Bend in the default path, suggest:

```sh
export PATH="$HOME/.bend:$PATH"
rehash
bend --version
```

Do not install, update, or make network requests silently. When `bend` is in the `PATH`, confirm that `command -v bend` points to `~/.bend/bend` or `bend`. Do not use `lab/bend study/Bend`, `util-repos/bend`, or any other checkout as the source of truth for the language, CLI, Base, or runtime.

The documentation and files of the target repository continue to be used solely to understand the logic to be formalized, locate tests, and identify the link between the original code and the Bend model. They do not replace the documentation provided by the installation at `~/.bend/`. ## Current Bend Model

The implementation must adhere to the Bend specifications found in the `~/.bend/` installation:

- Python-like syntax, with explicit annotations and minimal inference;
- pure language, with effects encapsulated in `IO`;
- affine values ​​by default (used at most once);
- `Data`, `Type`, kinds, and quantities (`-`, affine, and `+`);
- core types: `Nat`, `U32`, and `F32`;
- `match` for branching; do not introduce `if` or `switch`;
- terminating recursion, unless explicitly justified via `@unsafe`;
- single-owner arrays with `a[i] <- value` updates;
- independent calls using `a b = f(x) g(y)`;
- `f!(x)` to dispatch parallel calls to the GPU backend in native builds;
- one module per file and aliased imports;
- `do` blocks for `IO`, `Maybe`, `Result`, and other monads.

Do not use concepts from Bend 1/HVM as current references: `u24`, `i24`, `f24`, `run-rs`, `run-c`, `run-cu`, `gen-c`, `gen-cu`, HVM2/interaction nets, `fold`, `bend`, `fork`, `open`, `if`, or `switch`.

## Mandatory Testing and Proof Structure

Before creating any Bend tests or proofs, understand how the repository organizes them. Examine directories, conventions, `AGENTS.md`, package manager configurations, and C documentation.
