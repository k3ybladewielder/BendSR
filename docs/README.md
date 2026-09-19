# 🧬 Symbolic Regression in Bend

This repository contains a native implementation of **Symbolic Regression** built with **[Bend](https://github.com/bendlang/bend)** (by Higher Order Company), a massively parallel, functional programming language.

The evolutionary algorithm runs concurrently across GPUs/CPUs using Abstract Syntax Trees (ASTs) and leverages Bend 2's integrated proof checker to enforce safety invariants during stochastic operations.

---

## Motivation

Artificial Intelligence models for safety-critical domains (Safety-Critical ML), biological control, or embedded systems require strong interpretability and logical guarantees.

Symbolic Regression stands out by generating transparent mathematical expressions rather than black-box neural networks. Implementing it in Bend provides:
* **Lock-Free Massive Parallelism:** Concurrent evaluation of population generations on the GPU via tree-structured data.
* **Guaranteed Correctness (Guarded ML):** Using `LAWS.bend` and `PROOF.bend` to mathematically prove immutability, determinism, and numerical safety across stochastic mutations (preventing division-by-zero or silent NaNs).

---

## Quick Start

### 1. Prerequisites
* [Bend 2+ Installation](https://github.com/bendlang/bend) (Massive parallelism with `CUDA` or `Metal` requires installing from source/HVM).

---

### 2. Running the Project
Execute the main entry point from the `src/` directory to run the evolutionary algorithm on the default dataset ($y = x^2 + 1$):

```bash
# Run on CPU
bend run src/Main.bend

# Run on GPU (if CUDA/Metal is configured in your environment)
bend run -c src/Main.bend
```

---

### 3. Verifying Proofs (Proof Checker)
Bend allows formal verification of tree logic using its built-in proof checking system. To verify the laws defined in the codebase, run:
bend check src/PROOF.bend

---

### 4. How to Use for Discovering Custom Functions
To apply symbolic regression to your own dataset:
 * Open src/Main.bend.
 * Replace the dataset variable inside the main block with your data, formatted as a linked list of (x, y) tuples ((F32, F32)).
 * Adjust the hyperparameters passed to Engine.evolve!:
   * pop_len: Population size (e.g., 100u).
   * gen: Maximum number of generations (e.g., 50n).
     
```bash
📂 Repository Structure
.
├── docs/
│   └── README.md
└── src/
    ├── Types.bend
    ├── Eval.bend
    ├── Genetics.bend
    ├── Engine.bend
    ├── LAWS.bend
    ├── Main.bend
    └── PROOF.bend
```

---

### Source File Details (src/)
 * ```Types.bend```: Defines the foundational type system. Contains the recursive Abstract Syntax Tree (Expr) data structure encompassing terminals (x, constants) and non-linear operators (Sin, Cos, Exp), as well as the Individual representation.
 * ```Eval.bend```: Implements the parallel tree evaluation engine (eval). Handles numerical guardrails (safe_div) and computes Mean Absolute Error (MAE) concurrently across GPU threads using the ! operator.
 * ```Genetics.bend```: Handles AST manipulation routines. Combines mutate and crossover functions using immutable bitwise navigation via pattern matching, avoiding memory leaks or race conditions.
 * ```Engine.bend```: The core evolutionary pipeline. Manages tournament selection (tournament) and the recursive evaluation, breeding, and population replacement loop.
 * ```LAWS.bend```: The Bend 2 specification file. Declares formal assertions and laws that the codebase must satisfy (e.g., tree evaluation must be deterministic and reflexive at compile-time).
 * ```Main.bend```: Application CLI entry point. Initializes the random seed population (init_population), configures parameters, and feeds dataset points into the evolutionary engine.
 * ```PROOF.bend```: The proof resolution module. Solves and signs the assertions declared in LAWS.bend using strict reflexivity proofs.

