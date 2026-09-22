#!/usr/bin/env python3
"""
BendSR Dataset Loader Generator
Converts CSV, XLSX, or Parquet files into a native Bend dataset file (Dataset.bend) using Polars for high performance.
Supports single-variable (Pt) and multivariable (Pt2, Pt3) feature datasets.
"""

import sys
import os

def parse_file_polars(file_path: str):
    ext = os.path.splitext(file_path)[1].lower()
    
    try:
        import polars as pl
        if ext == '.csv':
            df = pl.read_csv(file_path)
        elif ext in ['.xlsx', '.xls']:
            df = pl.read_excel(file_path)
        elif ext in ['.parquet', '.pq']:
            df = pl.read_parquet(file_path)
        else:
            df = pl.read_csv(file_path)

        cols = df.columns
        num_cols = len(cols)
        data_rows = [list(r) for r in df.rows()]
        return num_cols, data_rows
    except ImportError:
        if ext == '.csv':
            import csv
            rows = []
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.reader(f)
                lines = [r for r in reader if r]
                start_idx = 0
                try:
                    float(lines[0][0])
                except (ValueError, IndexError):
                    start_idx = 1
                
                for r in lines[start_idx:]:
                    try:
                        parsed = [float(val) for val in r]
                        rows.append(parsed)
                    except ValueError:
                        continue
            num_cols = len(rows[0]) if rows else 0
            return num_cols, rows
        else:
            sys.stderr.write(f"Error: polars library is required to parse {ext} files. Run with `uv run --with polars`.\n")
            sys.exit(1)

def generate_bend_code(num_cols, rows):
    bend_code = "import ./Types.bend as Types\n\n"
    bend_code += "# Automatically generated multivariable dataset loader\n"
    bend_code += "def load_dataset() -> +List<Types.Point>:\n"
    
    indent = "  "
    for row in rows:
        if num_cols < 2:
            features = [row[0]]
            target = 0.0
        else:
            features = row[:-1]
            target = row[-1]
            
        xs_str = "Types.FNil{}"
        for val in reversed(features):
            xs_str = f"Types.FCon{{{val}, {xs_str}}}"
            
        pt_str = "Types.Pt{" + xs_str + ", " + str(target) + "}"

        bend_code += f"{indent}Con{{\n{indent}  {pt_str},\n"
        indent += "  "

    bend_code += f"{indent}Nil{{}}\n"
    for _ in range(len(rows)):
        indent = indent[:-2]
        bend_code += f"{indent}}}\n"

    return bend_code

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: uv run --with polars tools/load_dataset.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    num_cols, rows = parse_file_polars(file_path)
    print(generate_bend_code(num_cols, rows))
