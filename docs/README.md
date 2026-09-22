# 🧬 BendSR: Symbolic Regression in Bend

This repository contains a native implementation of **Symbolic Regression** built with **[Bend](https://github.com/bendlang/bend)** (by Higher Order Company), a massively parallel, functional programming language.

The evolutionary algorithm runs concurrently across GPUs/CPUs using Abstract Syntax Trees (ASTs) and leverages Bend 2's integrated proof checker to enforce safety invariants during stochastic operations.

---

## Motivation

Artificial Intelligence models for safety-critical domains (Safety-Critical ML), biological control, or embedded systems require strong interpretability and logical guarantees.

Symbolic Regression stands out by generating transparent mathematical expressions rather than black-box neural networks. Implementing it in Bend provides:
* **Lock-Free Massive Parallelism:** Concurrent evaluation of population generations on the GPU via tree-structured data.
* **Guaranteed Correctness (Guarded ML):** Using `LAWS.bend` and `PROOF.bend` to mathematically prove immutability, determinism, and numerical safety across stochastic mutations (preventing division-by-zero or silent NaNs).

---

## Application Cases

The repository includes a comprehensive suite of real-world benchmarks and business applications located in the [`cases/`](../cases/CASES.md) directory:

- **Physics & Discovery of Natural Laws** ([`cases/physics_feynman/`](../cases/physics_feynman/README.md)): Extracting governing physical laws (e.g., kinetic energy $E(v) = 0.5 \cdot v^2$).
- **Embedded Control Systems** ([`cases/control_systems/`](../cases/control_systems/README.md)): Generating lightweight closed-loop control laws for real-time edge devices ($u(x) = \sin(x) + 0.5 \cdot x$).
- **Quantitative Finance** ([`cases/financial_factors/`](../cases/financial_factors/README.md)): Discovering interpretable non-linear alpha factors ($\alpha(x) = x \cdot \cos(x)$).
- **Academic Benchmarks** ([`cases/synthetic_benchmarks/`](../cases/synthetic_benchmarks/README.md)): Validating convergence against standard synthetic suites (Nguyen-1: $f(x) = x^3 + x^2 + x$).
- **Dynamic Pricing & Elasticity** ([`cases/business_dynamic_pricing/`](../cases/business_dynamic_pricing/README.md)): Deducing demand curves for optimal price setting ($d(p) = \frac{100.0}{p} + 10.0$).
- **Auditable Churn Risk Scoring** ([`cases/business_churn_risk/`](../cases/business_churn_risk/README.md)): Transparent, GDPR-compliant customer risk scoring ($R(s) = 1.5 \cdot s + 2.0$).
- **Supply Chain Inventory Optimization** ([`cases/business_supply_chain/`](../cases/business_supply_chain/README.md)): Extracting reorder point and safety stock formulas ($ROP(d) = 2.5 \cdot d + 5.0$).

For detailed overviews, datasets, and Bend evaluation scripts, consult [`cases/CASES.md`](../cases/CASES.md).

---

## Quick Start

### 1. Prerequisites
* [Bend 2+ Installation](https://github.com/bendlang/bend) (Massive parallelism with `CUDA` or `Metal` requires installing from source/HVM).
* [uv](https://github.com/astral-sh/uv) (Fast Python package and project manager used for running dataset tools and helper scripts seamlessly without manual virtualenv setups).

---

### 2. Running the Project
Execute the main entry point from the `src/` directory to run the evolutionary algorithm on the default dataset ($y = x^2 + 1$):

```bash
# Run on CPU
bend src/Main.bend

# Run on GPU (if CUDA/Metal is configured in your environment)
bend -c src/Main.bend
```

---

### 3. Verifying Proofs (Proof Checker)
Bend allows formal verification of tree logic using its built-in proof checking system. To verify the laws defined in the codebase, run:
```bash
bend check src/PROOF.bend
```

---

### 4. Loading Custom Datasets (CSV, XLSX, Parquet)

#### Can Bend read tabular formats natively?
Bend is a pure functional language compiled to HVM (Higher-order Virtual Machine). It does not include native tabular file parsers for `.csv`, `.xlsx` (Excel), or `.parquet` in its core runtime.

#### How to load your own dataset into BendSR
Instead of manually hardcoding points into Bend code, use the automated dataset loader generator script (`tools/load_dataset.py`) via `uv`. It reads external `.csv`, `.xlsx`, or `.parquet` files and automatically outputs native Bend dataset AST structures.

**Step 1: Convert your dataset file into Bend format using `uv`**
Run the generator tool targeting your dataset file (specifying column indices if needed):

```bash
# Convert a CSV file
uv run tools/load_dataset.py path/to/your_dataset.csv > src/Dataset.bend

# Convert an XLSX or Parquet file (with automatic on-the-fly dependencies)
uv run --with pandas --with openpyxl --with pyarrow tools/load_dataset.py path/to/your_dataset.xlsx 0 1 > src/Dataset.bend
```

**Step 2: Import the generated dataset in `src/Main.bend`**
Open `src/Main.bend` and update `make_dataset` to import and call the generated loader:

```bend
import ./Dataset.bend as Dataset

def main() -> IO(Unit):
  run_evolution(Dataset.load_dataset(), init_population())
```

**Step 3: Execute the evolutionary search**
Run BendSR to discover the underlying mathematical formula for your data:

```bash
bend src/Main.bend
```

---

### 5. How to Discover Custom Functions & Adjust Parameters
To adjust evolutionary parameters in `src/Main.bend`:
 * Hyperparameters passed to `Engine.evolve!`:
   * `pop_len`: Population size (e.g., 100u).
   * `gen`: Maximum number of generations (e.g., 50n).

---

## Repository Structure

```text
.
├── cases/
│   ├── CASES.md
│   ├── physics_feynman/
│   ├── control_systems/
│   ├── financial_factors/
│   ├── synthetic_benchmarks/
│   ├── business_dynamic_pricing/
│   ├── business_churn_risk/
│   └── business_supply_chain/
├── docs/
│   └── README.md
├── tools/
│   └── load_dataset.py
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

### Source File Details (`src/`)
 * `Types.bend`: Defines the foundational type system. Contains the recursive Abstract Syntax Tree (`Expr`) data structure encompassing terminals ($x$, constants) and non-linear operators (`Sin`, `Cos`, `Exp`), as well as the `Individual` representation.
 * `Eval.bend`: Implements the parallel tree evaluation engine (`eval`). Handles numerical guardrails (`safe_div`) and computes Mean Absolute Error ($MAE$) concurrently across GPU threads using the `!` operator.
 * `Genetics.bend`: Handles AST manipulation routines. Combines `mutate` and `crossover` functions using immutable bitwise navigation via pattern matching, avoiding memory leaks or race conditions.
 * `Engine.bend`: The core evolutionary pipeline. Manages tournament selection (`tournament`) and the recursive evaluation, breeding, and population replacement loop.
 * `LAWS.bend`: The Bend 2 specification file. Declares formal assertions and laws that the codebase must satisfy (e.g., tree evaluation must be deterministic and reflexive at compile-time).
 * `Main.bend`: Application CLI entry point. Initializes the random seed population (`init_population`), configures parameters, and feeds dataset points into the evolutionary engine.
 * `PROOF.bend`: The proof resolution module. Solves and signs the assertions declared in `LAWS.bend` using strict reflexivity proofs.

---

## Citation

If you use BendSR in your research or project, please cite it as follows:

```bibtex
@misc{guimaraes2026bendsr,
  author       = {Guimar{\~a}es, Alysson},
  title        = {{BendSR: Symbolic Regression in Bend}},
  year         = {2026},
  month        = {sep},
  howpublished = {\url{https://github.com/k3ybladewielder/BendSR}},
  note         = {GitHub repository}
}
```
