# BendSR Application Cases & Benchmarks

**BendSR** is a **Symbolic Regression (SR)** implementation developed in the **Bend** programming language. The primary objective of BendSR is to leverage Bend's parallelism model based on *Interaction Nets* and interaction node rewriting to discover exact, interpretable analytical mathematical expressions directly from numerical datasets.

Unlike black-box deep learning models, Symbolic Regression searches the space of Abstract Syntax Trees (ASTs) of mathematical expressions to find an optimal function:
$$f(X) \approx y$$

> [!NOTE]
> **Synthetic Datasets Notice**: All case studies and datasets (`dataset.csv`) included in this directory are generated using **synthetic data** (dados sintéticos) specifically designed to test, validate, and benchmark **BendSR**'s symbolic regression discovery engine across single-variable and multivariable domains.

---

## Key Advantages of BendSR

1. **Massive Parallelism Without Manual CUDA**: Bend's runtime allows evaluating populations of expression trees across multiple CPU threads or GPU accelerators transparently and in parallel.
2. **100% Interpretable Modeling**: Produces explicit, closed-form equations, enabling auditing, formal proof, and seamless integration into edge micro-systems, e.g.:
$$f(x_1, x_2, x_3) = \sin(x_1) + \frac{x_2}{x_3}$$
3. **Overfitting Robustness**: Through multi-objective fitness functions (such as Pareto compromise between Mean Absolute Error $MAE$ and tree complexity $C$), it prevents unnecessarily complex solutions.
4. **Formal Verification and Correctness**: Supported by the Bend ecosystem's native verification and proving capabilities, properties of expressions and logical operators can be formally verified.

---

## Primary Application Domains

### 1. Physics & Discovery of Natural Laws ([`physics_feynman/`](./physics_feynman/README.md))
- **Discovery of Governing Field Equations and Conservation Laws**: Identifying physical governing laws from sensor time-series or simulation data (e.g., Kepler's laws, fluid dynamics equations, non-linear harmonic oscillators).
- **Complex Model Reduction**: Transforming computationally heavy numerical simulations into high-precision analytical approximations for real-time execution:
$$E(v) = 0.5 \cdot v^2$$

### 2. Multivariable Surface Discovery ([`multivariable_feynman/`](./multivariable_feynman/README.md))
- **Extraction of Multi-Feature Interactions**: Deductions over multi-dimensional feature spaces ($x_0, x_1, x_2, \dots$) identifying non-linear cross-variable interactions:
$$f(x_0, x_1) = x_0^2 + 2.0 \cdot x_1$$

### 3. Engineering & Control Systems ([`control_systems/`](./control_systems/README.md))
- **Analytical Control Laws for Edge Devices**: Generating closed-loop control functions without requiring neural network inference on resource-constrained hardware:
$$u(x) = \sin(x) + 0.5 \cdot x$$
- **Constitutive Material Laws**: Describing stress-strain behavior and fatigue of novel composite materials under varying temperatures $T$ and pressures $P$:
$$\sigma(\epsilon) = E \cdot \epsilon$$

### 4. Quantitative Finance & Econometrics ([`financial_factors/`](./financial_factors/README.md))
- **Construction of Financial Factors & Indicators**: Automatically discovering new interpretable *alpha* factors for trading strategies and asset pricing:
$$\alpha(x) = x \cdot \cos(x)$$
- **Risk Modeling & Volatility Surfaces**: Identifying analytical relationships for fitting volatility surfaces and synthetic risk assessment:
$$\sigma(K, T) = \sigma_0 + \alpha \cdot K$$

### 5. Computational Biology & Systems Medicine
- **Enzyme Kinetics & Gene Regulatory Networks**: Inferring ordinary differential equations (ODEs) and reaction rates from gene expression data:
$$v(S) = \frac{V_{\max} \cdot S}{K_m + S}$$
- **Pharmacokinetics & Pharmacodynamics (PK/PD)**: Modeling drug absorption and elimination rates in biological tissues:
$$C(t) = C_0 \cdot e^{-k \cdot t}$$

### 6. Computational Chemistry & Materials Science
- **Molecular Property Prediction**: Mapping molecular descriptors $x$ to physical-chemical properties (pKa, solubility, melting point) in a scientist-interpretable manner:
$$p(x) = a \cdot x + b$$

### 7. Academic Synthetic Benchmarks ([`synthetic_benchmarks/`](./synthetic_benchmarks/README.md))
- **Standard Symbolic Regression Test Suite (Nguyen-1)**: Validating convergence rates, exact formula recovery, and parallel execution speedup against classic benchmark targets:
$$f(x) = x^3 + x^2 + x$$

---

## Business Applications

### 1. Dynamic Pricing & Elasticity Modeling ([`business_dynamic_pricing/`](./business_dynamic_pricing/README.md))
- **Automated Price Elasticity Curve Discovery**: Extracting explicit demand functions from historical sales transaction data to optimize profit margins without relying on black-box neural networks:
$$d(p) = \frac{100.0}{p} + 10.0$$

### 2. Customer Churn & Auditable Credit Scoring ([`business_churn_risk/`](./business_churn_risk/README.md))
- **Regulatory-Compliant Scoring Models**: Discovering transparent risk score equations combining customer tenure $t$ and support interactions $s$ that guarantee auditability and regulatory compliance (e.g., GDPR/ECOA):
$$R(s) = 1.5 \cdot s + 2.0$$

### 3. Supply Chain & Inventory Optimization ([`business_supply_chain/`](./business_supply_chain/README.md))
- **Reorder Point & Buffer Stock Equations**: Extracting closed-form reorder point formulas based on daily demand $d$ and supplier lead time $L$ to minimize stockout risks while avoiding excess inventory:
$$ROP(d) = 2.5 \cdot d + 5.0$$

---

## `cases/` Directory Structure

The `BendSR/cases` directory hosts practical examples, reference datasets, and use-case implementations:

```text
BendSR/cases/
├── CASES.md                  # Overview document of application cases
├── physics_feynman/          # Physics-inspired benchmarks (classical physical equations)
├── multivariable_feynman/    # 2D/3D multivariable surface recovery (x0, x1, ...)
├── control_systems/          # Control law extraction examples
├── financial_factors/        # Analytical financial factor discovery cases
├── synthetic_benchmarks/     # Standard test functions (Koza, Nguyen, Pagie, Korns)
├── business_dynamic_pricing/ # Dynamic pricing and demand elasticity discovery
├── business_churn_risk/      # Auditable customer churn risk scoring
└── business_supply_chain/    # Inventory reorder point optimization
```

---

## Next Steps
- Implement scripts and specifications for standard synthetic benchmarks (e.g., Nguyen-1 through Nguyen-12).
- Add dataset generators for massively parallel evaluation via Bend.
