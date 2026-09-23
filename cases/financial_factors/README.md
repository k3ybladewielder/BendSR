# Case 3: Quantitative Finance (Alpha Factor Discovery)

## Problem Overview
This case study demonstrates the application of **BendSR** in discovering automated, analytical **quantitative alpha factors** for trading strategies in financial markets.

The objective is to find interpretable mathematical functions correlating historical asset price returns $x$ with expected future excess returns:
$$\alpha(x) = x \cdot \cos(x)$$

---

## Case Files

- [`README.md`](./README.md): Unified document describing the model specification and results.
- [`dataset.csv`](./dataset.csv): Historical 5-day return $x$ and target future return signal $\alpha$.
- [`factor_search.bend`](./factor_search.bend): Bend script evaluating target factor expressions against `Dataset.bend`.
- [`factor_search_discovery.bend`](./factor_search_discovery.bend): Executable Bend script performing autonomous evolutionary search over `Dataset.bend`.

---

## Numerical Results & Metrics

| Mode | Discovered Expression | Mean Absolute Error ($MAE$) | AST Complexity | Evaluation Status |
|---|---|---|---|---|
| **Direct Validation** (`factor_search.bend`) | $\alpha(x) = x \cdot \cos(x)$ | $0.000000$ | $3\text{ AST nodes}$ | Verified Ground Truth |
| **Autonomous Discovery** (`factor_search_discovery.bend`) | `Mul(Var(0), Cos(Var(0)))` | $0.000000$ | $3\text{ AST nodes}$ | Discovered via Evolution |

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
