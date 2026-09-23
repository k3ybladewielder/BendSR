# Multivariable Case: Physics Feynman 2D Surface Discovery

## Problem Overview
This case study demonstrates **BendSR**'s capability to discover multivariable physical and mathematical relationships involving multiple feature inputs ($x_0, x_1$).

The objective is to deduce the exact 2D surface equation combining quadratic and linear interaction terms:
$$f(x_0, x_1) = x_0^2 + 2.0 \cdot x_1$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing context, specifications, and results analysis.
- [`dataset.csv`](./dataset.csv): Observational dataset containing 1,000 samples of feature inputs ($x_0, x_1$) and target output $y$.
- [`feynman_multi.bend`](./feynman_multi.bend): Executable Bend script evaluating target multivariable symbolic expressions against `Dataset.bend`.
- [`feynman_multi_discovery.bend`](./feynman_multi_discovery.bend): Executable Bend script performing autonomous evolutionary search over `Dataset.bend`.

---

## Numerical Results & Metrics

| Mode | Discovered Expression | Mean Absolute Error ($MAE$) | AST Complexity | Evaluation Status |
|---|---|---|---|---|
| **Direct Validation** (`feynman_multi.bend`) | $f(x_0, x_1) = x_0^2 + 2.0 \cdot x_1$ | $0.000000$ | $7\text{ AST nodes}$ | Verified Ground Truth |
| **Autonomous Discovery** (`feynman_multi_discovery.bend`) | `Add(Mul(Var(0), Var(0)), Mul(Val(2.0), Var(1)))` | $0.000000$ | $7\text{ AST nodes}$ | Discovered via Evolution |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR analyzed multivariable data points ($x_0, x_1, y$) and autonomously discovered that the output $y$ is governed by a quadratic contribution from the first feature $x_0$ added to a scaled linear contribution from the second feature $x_1$:
$$f(x_0, x_1) = x_0^2 + 2.0 \cdot x_1$$

### What does this mean in practice?
1. **Multi-Dimensional Surface Extraction**: Real-world physical systems and engineering processes depend on multiple variables. BendSR scales to multivariate domains ($x_0, x_1, x_2, \dots$), discovering exact interaction effects between distinct physical parameters.
2. **Lock-Free Parallel Feature Evaluation**: Using Bend's Interaction Net runtime, evaluating feature vectors across multivariable AST nodes occurs concurrently without GPU memory bottlenecks or thread contention.
3. **Full Auditability Across Feature Dimensions**: BendSR outputs an explicit multi-feature formula, enabling closed-form mathematical analysis and safety verification.
