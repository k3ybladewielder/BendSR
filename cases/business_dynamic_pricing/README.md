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
BendSR discovered the exact price elasticity of demand curve relating unit selling price $p$ to consumer purchase volume $d$:
$$d(p) = \frac{100.0}{p} + 10.0$$

The formula proves that demand has two components: an **iso-elastic price-sensitive component** ($\frac{100.0}{p}$) and a **stubborn baseline demand** ($10.0$ units) that buys regardless of price.

### How does a business use this formula to set prices and maximize revenue?

1. **Analytical Revenue Maximization (Solving $P_{\text{opt}}$)**:
   - Total Revenue $R(p)$ is price times demand: 
     $$R(p) = p \cdot d(p) = p \cdot \left(\frac{100.0}{p} + 10.0\right) = 100.0 + 10.0 \cdot p$$
   - Taking the derivative with respect to price: $\frac{dR}{dp} = 10.0 > 0$.
   - **Business Decision**: Because $\frac{dR}{dp}$ is positive for all $p > 0$, the business learns that demand is inelastic over the benchmark price range. Raising the price increases revenue linearly without losing the core 10-unit baseline volume.

2. **Profit Optimization under Marginal Cost ($C_m$)**:
   - If unit production cost is $C_m = \$5.00$, Profit $\Pi(p) = (p - 5) \cdot d(p) = (p - 5) \cdot \left(\frac{100.0}{p} + 10\right) = 100 + 10p - \frac{500}{p} - 50 = 50 + 10p - \frac{500}{p}$.
   - Setting marginal profit to zero: $\frac{d\Pi}{dp} = 10 + \frac{500}{p^2} = 0$, showing profit increases monotonically with price up to customer saturation limits.

3. **Automated E-Commerce Pricing Engine Integration**:
   - Instead of running complex A/B price testing or machine learning models that require continuous retraining, the e-commerce platform embeds $d(p) = \frac{100.0}{p} + 10.0$ into its checkout API.
   - When competitor prices shift or supplier costs update, the system instantaneously recalculates the optimal price tag in microseconds.

4. **Executive & Governance Transparency**:
   - Board members and financial auditors do not need to trust a black-box AI model. The pricing team presents a clean 2-parameter mathematical curve that explains exactly how many sales will be gained or lost for any proposed price change.
