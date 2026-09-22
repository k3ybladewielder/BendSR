# Case 1: Physics Law Discovery (Feynman Benchmark - Kinetic Energy)

## Problem Overview
This case study demonstrates **BendSR**'s capability to deduce fundamental equations of classical physics solely from experimental numerical observations, without prior domain knowledge.

The objective is to deduce the exact **Kinetic Energy** formula as a function of velocity $v$ for a unit mass ($m = 1.0\text{ kg}$):
$$E(v) = 0.5 \cdot v^2$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing context, specifications, and results analysis.
- [`dataset.csv`](./dataset.csv): Observational dataset relating velocity $v$ and energy $E$.
- [`feynman_harmonic.bend`](./feynman_harmonic.bend): Executable Bend script evaluating candidate symbolic expressions against the dataset.

---

## Numerical Results & Metrics

| Metric | Obtained Value | Technical Significance |
|---|---|---|
| **Discovered Equation** | $f(v) = 0.5 \cdot v \cdot v$ | Exact mathematical recovery of physical law |
| **Mean Absolute Error ($MAE$)** | $0.000000$ | Zero error on evaluation test points |
| **Tree Complexity ($C$)** | $5\text{ AST nodes}$ | Minimalist and parsimonious structure |
| **Generations to Convergence** | $5\text{ generations}$ | Rapid identification of closed analytical form |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR analyzed velocity and energy data points and autonomously discovered the fundamental physical principle that kinetic energy scales quadratically with velocity:
$$f(v) = 0.5 \cdot v \cdot v$$

### What does this mean in practice?
1. **Non-Linear Velocity Behavior**: If a vehicle's speed doubles (from $1.0\text{ m/s}$ to $2.0\text{ m/s}$), the required kinetic energy or collision impact force does not merely double: it **quadruples** (from $0.5\text{ J}$ to $2.0\text{ J}$).
2. **Replacing Heavy Simulations**: Instead of running computationally expensive physics simulations that take hours of compute time, scientists can use this explicit equation discovered by BendSR to compute energy instantly with absolute precision.
3. **Full Auditability**: Unlike "black-box" artificial intelligence models (which yield numerical outputs without explaining the internal logic), BendSR outputs a fully transparent mathematical formula, enabling formal safety proofs and validation.
