#!/usr/bin/env python3
"""
Generate datasets for BendSR cases.
Supports specifying the number of feature columns via --cols (e.g. 10 for multivariable).
"""

import math
import argparse
import sys

def gen_multivariable_feynman(num_cols=10, num_rows=1000):
    path = "cases/multivariable_feynman/dataset.csv"
    headers = [f"x{i}" for i in range(num_cols)] + ["y"]
    with open(path, "w") as f:
        f.write(",".join(headers) + "\n")
        for i in range(num_rows):
            xs = [round((i + j) * 0.01, 2) for j in range(num_cols)]
            y = xs[0]**2 + 2.0 * xs[1] if num_cols >= 2 else xs[0]**2
            if num_cols > 2:
                y += sum(0.1 * xs[j] for j in range(2, num_cols))
            y = round(y, 4)
            row_str = ",".join(str(val) for val in xs) + f",{y}"
            f.write(row_str + "\n")

def gen_physics_feynman(num_rows=1000):
    path = "cases/physics_feynman/dataset.csv"
    with open(path, "w") as f:
        f.write("v,E_kinetic\n")
        for i in range(num_rows):
            v = round(i * 0.1, 2)
            E = round(0.5 * v * v, 4)
            f.write(f"{v},{E}\n")

def gen_control_systems(num_rows=1000):
    path = "cases/control_systems/dataset.csv"
    with open(path, "w") as f:
        f.write("x_error,u_control\n")
        for i in range(num_rows):
            x = round(i * 0.01, 2)
            u = round(math.sin(x) + 0.5 * x, 4)
            f.write(f"{x},{u}\n")

def gen_financial_factors(num_rows=1000):
    path = "cases/financial_factors/dataset.csv"
    with open(path, "w") as f:
        f.write("ret_5d,alpha_target\n")
        for i in range(num_rows):
            x = round(i * 0.01, 2)
            alpha = round(x * math.cos(x), 4)
            f.write(f"{x},{alpha}\n")

def gen_synthetic_benchmarks(num_rows=1000):
    path = "cases/synthetic_benchmarks/dataset.csv"
    with open(path, "w") as f:
        f.write("x,y_target\n")
        for i in range(num_rows):
            x = round(i * 0.01, 2)
            y = round(x**3 + x**2 + x, 4)
            f.write(f"{x},{y}\n")

def gen_business_dynamic_pricing(num_rows=1000):
    path = "cases/business_dynamic_pricing/dataset.csv"
    with open(path, "w") as f:
        f.write("price,demand\n")
        for i in range(num_rows):
            p = round(1.0 + i * 0.1, 2)
            d = round(100.0 / p + 10.0, 4)
            f.write(f"{p},{d}\n")

def gen_business_churn_risk(num_rows=1000):
    path = "cases/business_churn_risk/dataset.csv"
    with open(path, "w") as f:
        f.write("support_tickets,churn_risk_score\n")
        for i in range(num_rows):
            s = round(i * 0.1, 2)
            r = round(1.5 * s + 2.0, 4)
            f.write(f"{s},{r}\n")

def gen_business_supply_chain(num_rows=1000):
    path = "cases/business_supply_chain/dataset.csv"
    with open(path, "w") as f:
        f.write("daily_demand,reorder_point\n")
        for i in range(num_rows):
            d = round(1.0 + i * 0.1, 2)
            rop = round(2.5 * d + 5.0, 4)
            f.write(f"{d},{rop}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate datasets for BendSR cases.")
    parser.add_argument("--cols", type=int, default=10, help="Number of feature variables x0, x1, ... for multivariable (default: 10)")
    parser.add_argument("--rows", type=int, default=1000, help="Number of rows per dataset (default: 1000)")
    parser.add_argument("--case", type=str, default="all", help="Specific case to generate, or 'all'")
    
    args = parser.parse_args()

    if args.case in ["multivariable_feynman", "all"]:
        gen_multivariable_feynman(num_cols=args.cols, num_rows=args.rows)
    if args.case in ["physics_feynman", "all"]:
        gen_physics_feynman(num_rows=args.rows)
    if args.case in ["control_systems", "all"]:
        gen_control_systems(num_rows=args.rows)
    if args.case in ["financial_factors", "all"]:
        gen_financial_factors(num_rows=args.rows)
    if args.case in ["synthetic_benchmarks", "all"]:
        gen_synthetic_benchmarks(num_rows=args.rows)
    if args.case in ["business_dynamic_pricing", "all"]:
        gen_business_dynamic_pricing(num_rows=args.rows)
    if args.case in ["business_churn_risk", "all"]:
        gen_business_churn_risk(num_rows=args.rows)
    if args.case in ["business_supply_chain", "all"]:
        gen_business_supply_chain(num_rows=args.rows)
        
    print(f"Generated case datasets with --cols {args.cols} and --rows {args.rows}!")
