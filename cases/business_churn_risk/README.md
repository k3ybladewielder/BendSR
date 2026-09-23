# Business Case 2: Auditable Customer Churn & Credit Scoring

## Problem Overview
This business case applies **BendSR** to identify a transparent, auditable risk scoring equation based on customer support ticket volume $s$.

The risk scoring equation discovered by the algorithm is:
$$R(s) = 1.5 \cdot s + 2.0$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing context, specifications, and results analysis.
- [`dataset.csv`](./dataset.csv): Support ticket history $s$ and risk score $R$.
- [`churn_model.bend`](./churn_model.bend): Bend script evaluating target churn risk expressions against `Dataset.bend`.
- [`churn_model_discovery.bend`](./churn_model_discovery.bend): Executable Bend script performing autonomous evolutionary search over `Dataset.bend`.

---

## Numerical Results & Metrics

| Mode | Discovered Expression | Mean Absolute Error ($MAE$) | AST Complexity | Evaluation Status |
|---|---|---|---|---|
| **Direct Validation** (`churn_model.bend`) | $R(s) = 1.5 \cdot s + 2.0$ | $0.000000$ | $5\text{ AST nodes}$ | Verified Ground Truth |
| **Autonomous Discovery** (`churn_model_discovery.bend`) | `Add(Mul(Val(1.5), Var(0)), Val(2.0))` | $0.000000$ | $5\text{ AST nodes}$ | Discovered via Evolution |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR discovered that customer cancellation risk starts from a base risk score of $2.0$ points and increases linearly by $1.5$ points for every logged support ticket:
$$R(s) = 1.5 \cdot s + 2.0$$

### What does this mean in practice?
1. **Proactive Churn Prevention**: Customer Success teams know precisely when a customer enters the "red zone" of cancellation risk, enabling intervention before contract loss.
2. **Automated Regulatory Compliance**: Consumer protection and privacy regulations (such as GDPR Article 22) mandate that automated decision-making systems affecting consumers must be explainable. Because the scoring model is an open mathematical formula, it can be audited by regulators without trade secrets or black-box opacity.
