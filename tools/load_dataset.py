#!/usr/bin/env python3
"""
BendSR Dataset Loader Generator
Converts CSV, XLSX, or Parquet files into a native Bend dataset file (Dataset.bend) using Polars for high performance.
"""

import sys
import os

def parse_file_polars(file_path: str, x_col_idx: int = 0, y_col_idx: int = 1):
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

        x_name = df.columns[x_col_idx]
        y_name = df.columns[y_col_idx]
        
        # Extract tuples using polars expressions
        pts = list(zip(df[x_name].to_list(), df[y_name].to_list()))
        return pts
    except ImportError:
        # Fallback to standard library csv for CSV files
        if ext == '.csv':
            import csv
            points = []
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.reader(f)
                lines = [row for row in reader if row]
                start_idx = 0
                try:
                    float(lines[0][x_col_idx])
                except (ValueError, IndexError):
                    start_idx = 1
                
                for row in lines[start_idx:]:
                    if len(row) > max(x_col_idx, y_col_idx):
                        try:
                            points.append((float(row[x_col_idx]), float(row[y_col_idx])))
                        except ValueError:
                            continue
            return points
        else:
            sys.stderr.write(f"Error: polars library is required to parse {ext} files. Run with `uv run --with polars`.\n")
            sys.exit(1)

def generate_bend_code(points):
    bend_code = "import ./Types.bend as Types\n\n"
    bend_code += "# Automatically generated dataset loader\n"
    bend_code += "def load_dataset() -> +List<Types.Point>:\n"
    
    indent = "  "
    for x_val, y_val in points:
        bend_code += f"{indent}Con{{\n{indent}  Types.Pt{{{x_val}, {y_val}}},\n"
        indent += "  "
    bend_code += f"{indent}Nil{{}}\n"
    for _ in range(len(points)):
        indent = indent[:-2]
        bend_code += f"{indent}}}\n"

    return bend_code

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: uv run --with polars tools/load_dataset.py <file_path> [x_column_index] [y_column_index]")
        sys.exit(1)
    
    file_path = sys.argv[1]
    x_idx = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    y_idx = int(sys.argv[3]) if len(sys.argv) > 3 else 1

    pts = parse_file_polars(file_path, x_idx, y_idx)
    print(generate_bend_code(pts))
