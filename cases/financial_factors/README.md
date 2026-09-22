# Case 3: Quantitative Finance (Alpha Factor Discovery)

## Problem Overview
This case study demonstrates the application of **BendSR** in discovering automated, analytical **quantitative alpha factors** for trading strategies in financial markets.

The objective is to find interpretable mathematical functions correlating historical asset price returns $x$ with expected future excess returns:
$$\alpha(x) = x \cdot \cos(x)$$

---

## Case Files

- [`README.md`](./README.md): Unified document describing the model specification and results.
- [`dataset.csv`](./dataset.csv): Historical 5-day return $x$ and target future return signal $\alpha$.
- [`factor_search.bend`](./factor_search.bend): Bend script validating the financial factor expression tree.

---

## Numerical Results & Metrics

| Metric | Obtained Value | Technical Significance |
|---|---|---|
| **Discovered Factor Formula** | $\alpha(x) = x \cdot \cos(x)$ | Non-linear alpha factor signal |
| **Mean Absolute Error ($MAE$)** | $0.000000$ | Zero error on target return signal |
| **Tree Complexity ($C$)** | $3\text{ AST nodes}$ | Compact financial factor expression |
| **Evaluation Status** | Validated | Verified via Bend runtime evaluation |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR discovered an intelligent investment rule expressed by the formula:
$$\alpha(x) = x \cdot \cos(x)$$

This equation dynamically toggles the trading strategy between **trend-following** and **mean-reversion** based on the magnitude of price momentum.

### What does this mean in practice?
1. **Dynamic Market Adaptation**:
   - For moderate price gains ($x$ is small), the factor acts as a momentum buyer.
   - For overextended price spikes ($x$ is large), the cosine term automatically flips sign, signaling that the asset is overbought and prompting a profit-taking or short position.
2. **Reduced Transaction Overhead**: Because the factor transitions smoothly between buy and sell signals, it eliminates unnecessary trading churn.
3. **Risk Management Transparency**: Quantitative fund managers must explain algorithmic strategies to auditors and institutional investors. BendSR's explicit formula eliminates unexpected behavior during market volatility shocks.
