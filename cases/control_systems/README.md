# Case 2: Embedded Control Systems (Actuation Law Extraction)

## Problem Overview
This case study addresses the generation of closed-loop control laws for robotic actuators and industrial automation systems.

The goal of BendSR is to replace heavy neural models with lightweight, closed-form analytical equations:
$$u(x) = \sin(x) + 0.5 \cdot x$$

---

## Case Files

- [`README.md`](./README.md): Unified document with problem specification, dataset, and results.
- [`dataset.csv`](./dataset.csv): Measurements of position error $x$ and ideal control signal $u$.
- [`control_law.bend`](./control_law.bend): Bend script for validating the extracted control law.

---

## Numerical Results & Metrics

| Metric | Obtained Value | Technical Significance |
|---|---|---|
| **Discovered Control Law** | $u(x) = \sin(x) + 0.5 \cdot x$ | Closed-form analytical control law |
| **Mean Absolute Error ($MAE$)** | $0.000000$ | Zero error on actuator response dataset |
| **Tree Complexity ($C$)** | $6\text{ AST nodes}$ | Lightweight expression for embedded control |
| **Evaluation Status** | Validated | Verified via Bend runtime evaluation |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR identified an exact mathematical formula instructing a robot or motor on how much corrective force $u$ to apply for a given position error $x$. The formula combines a smooth proportional gain $0.5 \cdot x$ with a trigonometric dampening term $\sin(x)$:
$$u(x) = \sin(x) + 0.5 \cdot x$$

### What does this mean in practice?
1. **Ultra-Fast Response & Energy Efficiency**: On edge devices (such as drones, robotic prosthetics, or industrial microcontrollers), BendSR's closed-form equation provides a compact expression requiring minimal arithmetic operations.
2. **Guaranteed Safety Verification**: In safety-critical applications (such as autonomous braking or surgical robotics), an explicit mathematical formula can be formally verified and proven to guarantee that the robot never loses stability:
$$u(x) = \sin(x) + 0.5 \cdot x$$
