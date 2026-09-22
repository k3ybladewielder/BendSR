#!/usr/bin/env python3
"""
Generate 1000 row datasets for all 7 BendSR cases.
"""

import math

def gen_physics_feynman():
    path = "cases/physics_feynman/dataset.csv"
    with open(path, "w") as f:
        f.write("v,E_kinetic\n")
        for i in range(1000):
            v = round(i * 0.1, 2)
            E = round(0.5 * v * v, 4)
            f.write(f"{v},{E}\n")

def gen_control_systems():
    path = "cases/control_systems/dataset.csv"
    with open(path, "w") as f:
        f.write("x_error,u_control\n")
        for i in range(1000):
            x = round(i * 0.01, 2)
            u = round(math.sin(x) + 0.5 * x, 4)
            f.write(f"{x},{u}\n")

def gen_financial_factors():
    path = "cases/financial_factors/dataset.csv"
    with open(path, "w") as f:
        f.write("ret_5d,alpha_target\n")
        for i in range(1000):
            x = round(i * 0.01, 2)
            alpha = round(x * math.cos(x), 4)
            f.write(f"{x},{alpha}\n")

def gen_synthetic_benchmarks():
    path = "cases/synthetic_benchmarks/dataset.csv"
    with open(path, "w") as f:
        f.write("x,y_target\n")
        for i in range(1000):
            x = round(i * 0.01, 2)
            y = round(x**3 + x**2 + x, 4)
            f.write(f"{x},{y}\n")

def gen_business_dynamic_pricing():
    path = "cases/business_dynamic_pricing/dataset.csv"
    with open(path, "w") as f:
        f.write("price,demand\n")
        for i in range(1000):
            p = round(1.0 + i * 0.1, 2)
            d = round(100.0 / p + 10.0, 4)
            f.write(f"{p},{d}\n")

def gen_business_churn_risk():
    path = "cases/business_churn_risk/dataset.csv"
    with open(path, "w") as f:
        f.write("support_tickets,churn_risk_score\n")
        for i in range(1000):
            s = round(i * 0.1, 2)
            r = round(1.5 * s + 2.0, 4)
            f.write(f"{s},{r}\n")

def gen_business_supply_chain():
    path = "cases/business_supply_chain/dataset.csv"
    with open(path, "w") as f:
        f.write("daily_demand,reorder_point\n")
        for i in range(1000):
            d = round(1.0 + i * 0.1, 2)
            rop = round(2.5 * d + 5.0, 4)
            f.write(f"{d},{rop}\n")

if __name__ == "__main__":
    gen_physics_feynman()
    gen_control_systems()
    gen_financial_factors()
    gen_synthetic_benchmarks()
    gen_business_dynamic_pricing()
    gen_business_churn_risk()
    gen_business_supply_chain()
    print("All 7 CSV datasets generated with 1000 rows each!")
