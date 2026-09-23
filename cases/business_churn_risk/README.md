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
BendSR extracted a closed-form customer churn risk equation relating logged support tickets $s$ to cancellation risk score $R$:
$$R(s) = 1.5 \cdot s + 2.0$$

The equation identifies two operational parameters: a **baseline churn risk** ($2.0$ points) present for every active customer, and a **marginal ticket risk multiplier** ($1.5$ points per support ticket logged).

### How does a business use this formula in practice?

1. **Automated Risk Threshold Triggers (Customer Success Operations)**:
   - Operations teams set explicit mathematical risk boundaries:
     - **Green Zone ($R < 5.0$)**: Low risk. Customer logged $s < 2$ tickets. Standard automated check-in.
     - **Yellow Zone ($5.0 \le R < 9.5$)**: Moderate risk. $s \in [2, 5]$ tickets. Triggers an automated satisfaction survey and priority support queue routing.
     - **Red Zone ($R \ge 9.5$)**: High churn probability. $s \ge 5$ tickets. Triggers an instant notification to account managers to offer dedicated technical support or contract discounts before cancellation.

2. **GDPR / Regulatory Compliance & Black-Box Elimination**:
   - Regulations like **GDPR Article 22** and credit fairness acts require that automated decisions affecting consumers be explainable.
   - If a customer is flagged as "high risk" or denied credit renewal, auditors do not accept "the neural network outputted 0.87". With $R(s) = 1.5 \cdot s + 2.0$, the company provides a transparent, auditable formula proving the decision was based strictly on support ticket volume.

3. **Zero-Latency Micro-Service Deployment**:
   - The formula compiles to 2 arithmetic operations (`MUL` and `ADD`), allowing it to run inside lightweight database triggers, webhooks, or mobile SDKs without calling heavy ML inference servers.
