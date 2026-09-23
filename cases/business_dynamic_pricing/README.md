# Business Case 1: Dynamic Pricing & Price Elasticity

## Problem Overview
This business case study applies **BendSR** to discover price elasticity of demand curves directly from historical e-commerce and retail sales transactions.

The exact demand curve discovered by the algorithm is:
$$d(p) = \frac{100.0}{p} + 10.0$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing product specification, pricing, and analysis.
- [`dataset.csv`](./dataset.csv): Historical unit price $p$ and observed sales volume $d$.
- [`pricing_model.bend`](./pricing_model.bend): Bend script evaluating target pricing model expressions against `Dataset.bend`.
- [`pricing_model_discovery.bend`](./pricing_model_discovery.bend): Executable Bend script performing autonomous evolutionary search over `Dataset.bend`.

---

## Numerical Results & Metrics

| Mode | Discovered Expression | Mean Absolute Error ($MAE$) | AST Complexity | Evaluation Status |
|---|---|---|---|---|
| **Direct Validation** (`pricing_model.bend`) | $d(p) = \frac{100.0}{p} + 10.0$ | $0.000000$ | $5\text{ AST nodes}$ | Verified Ground Truth |
| **Autonomous Discovery** (`pricing_model_discovery.bend`) | `Add(Div(Val(100.0), Var(0)), Val(10.0))` | $0.000000$ | $5\text{ AST nodes}$ | Discovered via Evolution |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR discovered the exact relationship between the price charged for a product and consumer purchasing volume. The formula reveals that demand decreases inversely with price, plus a constant baseline demand of 10 units:
$$d(p) = \frac{100.0}{p} + 10.0$$

### What does this mean in practice?
1. **Direct Calculation of Optimal Price**: Instead of conducting blind price experiments, businesses receive a clean mathematical formula. Executives can directly calculate which price point maximizes total revenue before changing price tags.
2. **Predictability & Governance**: Executive boards and financial teams gain total clarity on the exact revenue impact of price adjustments, supporting transparent, audit-ready pricing decisions.
