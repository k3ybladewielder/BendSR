# Business Case 1: Dynamic Pricing & Price Elasticity

## Problem Overview
This business case study applies **BendSR** to discover price elasticity of demand curves directly from historical e-commerce and retail sales transactions.

The exact demand curve discovered by the algorithm is:
$$d(p) = \frac{100.0}{p} + 10.0$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing product specification, pricing, and analysis.
- [`dataset.csv`](./dataset.csv): Historical unit price $p$ and observed sales volume $d$.
- [`pricing_model.bend`](./pricing_model.bend): Bend script validating the pricing model.

---

## Numerical Results & Revenue Optimization

| Unit Price $p$ | Predicted Demand | Expected Revenue | Price Elasticity $E_p$ |
|---|---|---|---|
| $\$1.00$ | 110 units | $\$110.00$ | $-0.909$ |
| $\$2.00$ | 60 units | $\$120.00$ | $-0.833$ |
| $\$5.00$ | 30 units | $\$150.00$ | $-0.667$ |
| **$\$10.00$** | **20 units** | **$\$200.00$ (Optimal Point)** | **$-0.500$** |
| $\$20.00$ | 15 units | $\$300.00$ | $-0.333$ |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR discovered the exact relationship between the price charged for a product and consumer purchasing volume. The formula reveals that demand decreases inversely with price, plus a constant baseline demand of 10 units:
$$d(p) = \frac{100.0}{p} + 10.0$$

### What does this mean in practice?
1. **Direct Calculation of Optimal Price**: Instead of conducting blind price experiments or relying on black-box machine learning models, businesses receive a clean mathematical formula. Executives can directly calculate which price point maximizes total revenue before changing price tags.
2. **Predictability & Governance**: Executive boards and financial teams gain total clarity on the exact revenue impact of price adjustments, supporting transparent, audit-ready pricing decisions.
