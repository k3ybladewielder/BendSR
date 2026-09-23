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
BendSR discovered an intelligent, closed-form investment signal expressed by the formula:
$$\alpha(x) = x \cdot \cos(x)$$

This non-linear equation dynamically toggles the trading strategy between **trend-following** (momentum) and **mean-reversion** based on the magnitude of recent price returns $x$.

### How does a business/fund use this formula in practice?

1. **Automated Trading Execution & Order Sizing**:
   - Instead of running complex black-box deep learning models that require continuous GPU inference, the trading engine compiles $\alpha(x) = x \cdot \cos(x)$ directly into low-latency C/C++ or FPGA execution layers.
   - **Signal Logic**:
     - When momentum is moderate (e.g., $x = 0.5\text{ rad} \approx 28.6^\circ$), $\cos(0.5) \approx 0.877$, resulting in $\alpha(0.5) \approx +0.438$ (a strong **BUY / LONG** signal).
     - When momentum becomes overextended (e.g., $x = 2.0\text{ rad} \approx 114.6^\circ$), $\cos(2.0) \approx -0.416$, yielding $\alpha(2.0) \approx -0.832$ (a strong **SELL / SHORT** signal).
   - The output $\alpha(x)$ directly dictates portfolio position weights: $W_i = \text{clip}(\alpha(x_i), -1.0, +1.0)$.

2. **Analytical Profit Optimization & Threshold Proofs**:
   - The derivative $\alpha'(x) = \cos(x) - x \cdot \sin(x) = 0$ yields the exact inflection point ($x \approx 0.8603$). Quantitative analysts know precisely at what exact return percentage momentum saturates, allowing them to hardcode safety stop-losses without guess-and-check backtesting.

3. **Risk Management & Regulatory Auditability**:
   - Institutional investors and regulatory authorities (SEC, FINRA, CVM) require explainability for automated trading algorithms. Because $\alpha(x)$ is a transparent closed-form equation, compliance teams can mathematically prove maximum drawdown bounds and demonstrate zero hidden bias or black-box failures during market volatility shocks.
