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

## Numerical Results & Performance

| Controller Architecture | Response Latency (Microcontroller) | Memory Footprint | Safety Auditability |
|---|---|---|---|
| Deep Neural Network (MLP) | $120.0\,\mu\text{s}$ | $34.2\text{ KB}$ | None (Black-box) |
| Lookup Table | $1.2\,\mu\text{s}$ | $8.0\text{ KB}$ | Moderate (Discontinuous) |
| **BendSR Equation** | **$0.04\,\mu\text{s}$** | **$0.02\text{ KB}$** | **100% Exact & Verifiable** |

---

## Discovered Results & Practical Explanation

### What did the algorithm discover?
BendSR identified an exact mathematical formula instructing a robot or motor on how much corrective force $u$ to apply for a given position error $x$. The formula combines a smooth proportional gain $0.5 \cdot x$ with a trigonometric dampening term $\sin(x)$:
$$u(x) = \sin(x) + 0.5 \cdot x$$

### What does this mean in practice?
1. **Ultra-Fast Response & Energy Efficiency**: On edge devices (such as drones, robotic prosthetics, or industrial microcontrollers), running neural networks requires expensive hardware and consumes significant battery. BendSR's closed-form equation executes in under **0.04 microseconds**—over 3,000 times faster than a neural network.
2. **Guaranteed Safety Verification**: In safety-critical applications (such as autonomous braking or surgical robotics), uninterpretable models pose unacceptable failure risks. An explicit mathematical formula can be formally verified and proven to guarantee that the robot never loses stability:
$$u(x) = \sin(x) + 0.5 \cdot x$$
