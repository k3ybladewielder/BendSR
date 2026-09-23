# Case 1: Physics Law Discovery (Feynman Benchmark - Kinetic Energy)

## Problem Overview
This case study demonstrates **BendSR**'s capability to deduce fundamental equations of classical physics solely from experimental numerical observations, without prior domain knowledge.

The objective is to deduce the exact **Kinetic Energy** formula as a function of velocity $v$ for a unit mass ($m = 1.0\text{ kg}$):
$$E(v) = 0.5 \cdot v^2$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing context, specifications, and results analysis.
- [`dataset.csv`](./dataset.csv): Observational dataset relating velocity $v$ and energy $E$.
- [`feynman_harmonic.bend`](./feynman_harmonic.bend): Executable Bend script evaluating target symbolic expressions against `Dataset.bend`.
- [`feynman_harmonic_discovery.bend`](./feynman_harmonic_discovery.bend): Executable Bend script performing autonomous evolutionary search over `Dataset.bend`.

---

## Numerical Results & Metrics

| Mode | Discovered Expression | Mean Absolute Error ($MAE$) | AST Complexity | Evaluation Status |
|---|---|---|---|---|
| **Direct Validation** (`feynman_harmonic.bend`) | $f(v) = 0.5 \cdot v^2$ | $0.000000$ | $5\text{ AST nodes}$ | Verified Ground Truth |
| **Autonomous Discovery** (`feynman_harmonic_discovery.bend`) | `Mul(Val(0.5), Mul(Var(0), Var(0)))` | $0.000000$ | $5\text{ AST nodes}$ | Discovered via Evolution |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR analyzed velocity and energy data points and autonomously discovered the fundamental physical principle that kinetic energy scales quadratically with velocity:
$$f(v) = 0.5 \cdot v \cdot v$$

### What does this mean in practice?
1. **Non-Linear Velocity Behavior**: If a vehicle's speed doubles (from $1.0\text{ m/s}$ to $2.0\text{ m/s}$), the required kinetic energy or collision impact force does not merely double: it **quadruples** (from $0.5\text{ J}$ to $2.0\text{ J}$).
2. **Replacing Heavy Simulations**: Instead of running computationally expensive physics simulations that take hours of compute time, scientists can use this explicit equation discovered by BendSR to compute energy instantantly with absolute precision.
3. **Full Auditability**: BendSR outputs a fully transparent mathematical formula, enabling formal safety proofs and validation.
