# Business Case 2: Auditable Customer Churn & Credit Scoring

## Problem Overview
This business case applies **BendSR** to identify a transparent, auditable risk scoring equation based on customer support ticket volume $s$.

The risk scoring equation discovered by the algorithm is:
$$R(s) = 1.5 \cdot s + 2.0$$

---

## Case Files

- [`README.md`](./README.md): Unified document containing context, specifications, and results analysis.
- [`dataset.csv`](./dataset.csv): Support ticket history $s$ and risk score $R$.
- [`churn_model.bend`](./churn_model.bend): Bend script validating the risk model.

---

## Numerical Results & Metrics

| Metric | Obtained Value | Technical Significance |
|---|---|---|
| **Discovered Risk Equation** | $R(s) = 1.5 \cdot s + 2.0$ | Closed-form churn risk equation |
| **Mean Absolute Error ($MAE$)** | $0.000000$ | Zero error on risk score dataset |
| **Tree Complexity ($C$)** | $5\text{ AST nodes}$ | Interpretable linear AST structure |
| **Evaluation Status** | Validated | Verified via Bend runtime evaluation |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR discovered that customer cancellation risk starts from a base risk score of $2.0$ points and increases linearly by $1.5$ points for every logged support ticket:
$$R(s) = 1.5 \cdot s + 2.0$$

### What does this mean in practice?
1. **Proactive Churn Prevention**: Customer Success teams know precisely when a customer enters the "red zone" of cancellation risk, enabling intervention before contract loss.
2. **Automated Regulatory Compliance**: Consumer protection and privacy regulations (such as GDPR Article 22) mandate that automated decision-making systems affecting consumers must be explainable. Because the scoring model is an open mathematical formula, it can be audited by regulators without trade secrets or black-box opacity.
