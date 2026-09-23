---
name: hpc
description: High Performance Computing principles applied to Python data pipelines. Guides vectorization, parallelism, memory management, data locality, compact types, and I/O optimization with pandas/numpy. Use when optimizing data pipeline performance, reducing memory usage, or writing compute-intensive code.
keywords: ["hpc", "performance", "vectorization", "parallelism", "memory", "numpy", "einsum", "simd", "parquet", "optimization", "profiling", "data-locality"]
---

# High Performance Computing (HPC) for Data Pipelines

## What It Is

High Performance Computing (HPC) is the discipline of maximizing computational throughput through optimizations in memory, parallelism, vectorization, and I/O. In data pipelines, HPC is not about clusters or supercomputers — it's about extracting maximum performance from available hardware by eliminating CPU, memory, and I/O waste.

HPC complements DOP: while DOP defines the **structure** of code (purity, immutability, composition), HPC defines the **efficiency** of execution (locality, vectorization, parallelism).

---

## Core Principles

### 1. Data Locality
- Data accessed together should be stored together in memory
- Columnar layout (SoA — Struct of Arrays) is superior to row-based (AoS) for analytics
- Avoid `object` columns with Python lists — prefer contiguous NumPy arrays
- Each individual `.assign()` allocates a new DataFrame; grouping assignments reduces copies

### 2. Vectorization (SIMD)
- Operations on entire arrays via NumPy/pandas are 10-100x faster than Python loops
- The Python interpreter has overhead per iteration; vectorization eliminates this overhead
- `str.contains()` in pandas operates in C; `for row in df.iterrows()` runs in pure Python
- Never iterate over rows — use column operations, `np.where`, `np.einsum`

### 3. Parallelism
- **Data Parallelism**: same operation applied to different data partitions simultaneously
- **Task Parallelism**: independent operations executed in parallel
- **Pipeline Parallelism**: independent pipeline stages can be overlapped
- Python's GIL blocks threads for CPU-bound work; use processes for real parallelism

### 4. Memory Management
- Immutability has a cost: each copy consumes RAM
- Copy-on-Write (CoW) maintains immutable semantics without physical copy until actual mutation
- Explicit `gc.collect()` after `del` of large DataFrames frees memory immediately
- Process in chunks when data exceeds available RAM

### 5. I/O Optimization
- Columnar storage (Parquet) allows reading only necessary columns — O(columns read)
- Partitioning by filter keys (date, entity_id) enables partition pruning
- Compression reduces disk/network I/O; `zstd` balances ratio vs speed

### 6. Lazy Evaluation
- Eager evaluation executes each operation immediately (default pandas)
- Lazy evaluation builds a plan and optimizes before executing (Polars, Spark)
- Automatic optimizations: predicate pushdown, column pruning, operator fusion

### 7. Efficient Linear Algebra
- BLAS (Basic Linear Algebra Subprograms) uses hardware SIMD instructions
- `np.einsum` is more efficient than loops for batch dot products
- For high-dimensional neighbor search: ANN (FAISS, annoy) is O(log n) vs O(n²)

### 8. Compact Data Types
- `float64` uses 8 bytes; `float32` uses 4 bytes — 50% less RAM for normalized metrics
- `pd.Categorical` for low-cardinality columns (labels, source) — ~90% less RAM
- Downcasting reduces memory footprint without information loss

### 9. Profile Before Optimizing
- Amdahl's Law: maximum speedup is limited by the non-parallelizable fraction
- Optimize the real bottleneck (identified by profiling), not what "seems" slow
- Measure before and after each optimization to validate gains

---

## Patterns

### 1. Data Locality — Memory Layout

**When it matters:** Any time you work with arrays, matrices, or DataFrames. Data that is accessed together should be stored together in contiguous memory. This is critical for CPU cache efficiency — accessing scattered memory (pointer chasing) is orders of magnitude slower than sequential access.

**How to optimize:**

- **Prefer columnar layout (Struct of Arrays)** over row-based (Array of Structs). DataFrames are naturally columnar; keep it that way. Never store Python lists inside DataFrame cells (creates scattered heap objects).
- **Store numerical collections as contiguous NumPy arrays** (`np.ndarray`) rather than Python lists or lists-of-lists. NumPy arrays sit in a single contiguous block that the CPU can prefetch.
- **Batch column assignments** into a single `.assign()` call. Each individual `.assign()` allocates an entire new DataFrame. N calls = N copies; 1 call with N keywords = 1 copy.
- **Use Arrow-backed string types** (`"string[pyarrow]"`) instead of the default `object` dtype for string columns. Arrow strings are stored in contiguous buffers rather than as scattered Python `str` objects.

```python
import numpy as np
import pandas as pd

# ❌ Scattered: object column with Python lists (each row is a separate heap object)
df["vector"] = df["text"].apply(lambda t: some_function(t).tolist())

# ✅ Contiguous: external ndarray with shape (n, dim)
vectors = np.stack([some_function(t) for t in df["text"]], dtype=np.float32)

# ❌ Multiple copies: each .assign() allocates a new DataFrame
df = df.assign(a=va).assign(b=vb).assign(c=vc).assign(d=vd)  # 4 copies

# ✅ Single copy: batch assign
df = df.assign(a=va, b=vb, c=vc, d=vd)  # 1 copy

# ✅ Arrow-backed strings for better memory locality
df["name"] = df["name"].astype("string[pyarrow]")
```

### 2. Vectorization — Eliminate Python Loops

**When it matters:** Every time you need to apply an operation to all rows/elements of a column or array. The Python interpreter has significant per-iteration overhead (~100ns per iteration). Vectorized operations delegate the loop to C/Fortran and process the entire array in one call.

**How to optimize:**

- **Never use `iterrows()` or `itertuples()` for computation.** They create a Python object per row and are 50-100x slower than vectorized equivalents.
- **Replace `apply(lambda)` with native pandas/numpy operations** whenever possible. The `.str` accessor, arithmetic operators, `np.where`, and boolean indexing are all vectorized.
- **Use `np.einsum` for multi-dimensional operations** that would otherwise require nested loops (dot products, outer products, traces over specific axes).
- **Use `str.contains()` with regex for pattern matching** — it runs in C internally. A Python loop checking substrings one by one is dramatically slower.

```python
# ❌ Loop: Python overhead per row
totals = []
for _, row in df.iterrows():
    totals.append(row["price"] * row["qty"])
df["total"] = totals

# ✅ Vectorized: single C-level operation on entire columns
df["total"] = df["price"] * df["qty"]

# ❌ apply: runs Python function per element
df["length"] = df["text"].apply(lambda t: len(t.split()))

# ✅ Vectorized string accessor: C-optimized
df["length"] = df["text"].str.split().str.len()

# ❌ Loop for conditional logic
labels = []
for val in df["score"]:
    labels.append("high" if val > 0.8 else "low")

# ✅ Vectorized conditional
df["label"] = np.where(df["score"] > 0.8, "high", "low")

# ❌ Loop for regex classification
matches = []
for text in df["content"]:
    matches.append(bool(re.search(pattern, text)))

# ✅ Vectorized regex (runs in C)
df["matches"] = df["content"].str.contains(pattern, na=False)
```

### 3. Parallelism — Exploit Data Independence

**When it matters:** When your pipeline has independent operations that can run simultaneously — either multiple I/O calls (API requests, file reads) or CPU-intensive work on independent data partitions.

**How to optimize:**

- **ThreadPoolExecutor for I/O-bound work** (API calls, file reads, network requests). The GIL is released during I/O, so threads provide real concurrency.
- **ProcessPoolExecutor for CPU-bound work** (numerical computation, data transformation). Each process has its own interpreter and GIL, enabling true parallelism on multi-core CPUs.
- **asyncio for high-concurrency I/O** (hundreds/thousands of simultaneous requests). Lower overhead than threads when managing many connections.
- **Identify independent pipeline stages** and run them concurrently. If step A and step B don't depend on each other's output, they can execute in parallel.

```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
import asyncio

# Task parallelism: two independent I/O operations
with ThreadPoolExecutor(max_workers=2) as pool:
    future_a = pool.submit(load_dataset, "source_a.parquet")
    future_b = pool.submit(load_dataset, "source_b.parquet")
    data_a = future_a.result()
    data_b = future_b.result()

# Data parallelism: same transform on independent chunks (CPU-bound)
def transform_chunk(chunk: pd.DataFrame) -> pd.DataFrame:
    return chunk.pipe(normalize).pipe(compute_features)

chunks = np.array_split(df, num_cores)
with ProcessPoolExecutor(max_workers=num_cores) as pool:
    results = list(pool.map(transform_chunk, chunks))
df_result = pd.concat(results, ignore_index=True)

# Async I/O: many concurrent network requests
async def fetch_all(urls: list[str]) -> list[dict]:
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.json() for r in responses]
```

### 4. Memory Management

**When it matters:** In multi-step pipelines where each step produces a new DataFrame. Without explicit cleanup, intermediate results accumulate and can exhaust available RAM. This is especially important when working with immutable data (DOP pattern) since each transformation creates a new copy.

**How to optimize:**

- **Delete intermediate DataFrames** with `del` followed by `gc.collect()` as soon as they're no longer needed. Python's garbage collector may not reclaim memory immediately otherwise.
- **Enable Copy-on-Write** (`pd.set_option("mode.copy_on_write", True)`) to get immutable semantics without paying for physical copies until a mutation actually occurs.
- **Consolidate boolean filters** into a single combined mask before applying. Each `df[mask]` creates a new DataFrame; combining N masks into one reduces N allocations to 1.
- **Process in chunks** when the full dataset doesn't fit in RAM. Read and process partitions sequentially, accumulating results.

```python
import gc
import pandas as pd

# Enable CoW globally: immutable semantics without physical copies
pd.set_option("mode.copy_on_write", True)

# ✅ Explicit memory release between pipeline stages
df_clean = clean(df_raw)
del df_raw
gc.collect()

df_features = extract_features(df_clean)
del df_clean
gc.collect()

# ✅ Consolidated filters: one allocation instead of many
mask = (df["amount"] > 0) & (df["status"] == "active") & (df["date"] >= cutoff)
df_filtered = df[mask].copy()

# ❌ Sequential filters: multiple copies
df = df[df["amount"] > 0]          # copy 1
df = df[df["status"] == "active"]  # copy 2
df = df[df["date"] >= cutoff]      # copy 3
```

### 5. I/O Optimization — Columnar Storage

**When it matters:** Whenever reading or writing tabular data to disk. CSV is row-oriented and requires reading the entire file. Columnar formats (Parquet, Arrow IPC) allow reading only the columns and row groups you need, dramatically reducing I/O.

**How to optimize:**

- **Always specify `columns=` when reading Parquet.** If you need 3 of 30 columns, you read 10% of the data from disk.
- **Use compression** (`zstd` for best ratio, `snappy` for speed). Compressed files are smaller on disk, so less I/O even though decompression costs some CPU.
- **Partition large datasets** by commonly-filtered keys (date, region, entity type). Query engines can skip entire partitions (partition pruning).
- **Use predicate pushdown** with `filters=` parameter when reading partitioned Parquet directories. Rows are filtered at the storage level before loading into memory.

```python
# ✅ Column pruning: read only what you need
df = pd.read_parquet("data.parquet", columns=["id", "date", "amount"])

# ✅ Write with compression
df.to_parquet("output.parquet", index=False, compression="zstd")

# ✅ Partitioning by filter key
df.to_parquet("data/", index=False, partition_cols=["year", "month"], compression="zstd")

# ✅ Predicate pushdown: filter at storage level
df = pd.read_parquet(
    "data/",
    filters=[("year", "==", 2025), ("month", ">=", 6)],
    columns=["id", "amount"],
)
```

### 6. Lazy Evaluation

**When it matters:** When your dataset is large enough that eager execution (computing each step immediately) becomes wasteful — either because intermediate results are never fully used, or because the query engine can optimize the execution plan (reorder operations, push filters down, prune columns).

**How to optimize:**

- **Use Polars lazy mode** (`pl.scan_parquet`, `pl.LazyFrame`) for datasets that benefit from plan optimization. The engine automatically applies predicate pushdown, column pruning, and operator fusion.
- **In pandas, use `.query()` for complex filters** — it can be faster than chained boolean indexing because it avoids materializing intermediate boolean arrays.
- **Defer computation to the end** — build up your transformation plan, then call `.collect()` once. This gives the optimizer maximum freedom to rearrange and fuse operations.

```python
import polars as pl

# Lazy plan: no execution until .collect()
result = (
    pl.scan_parquet("data/*.parquet")
    .filter(pl.col("date") >= "2025-01-01")
    .select(["id", "amount", "category"])
    .group_by("category")
    .agg([
        pl.col("amount").mean().alias("avg_amount"),
        pl.col("amount").sum().alias("total"),
        pl.len().alias("count"),
    ])
    .collect()  # optimized execution happens here
)

# In pandas: query() avoids intermediate boolean arrays
df_filtered = df.query("amount > 100 and status == 'active' and date >= @cutoff")
```

### 7. Efficient Linear Algebra

**When it matters:** Any time you compute distances, similarities, projections, or aggregations over vectors/matrices — common in ML pipelines, recommendation systems, embedding comparisons, and feature engineering. Python loops over matrix elements are catastrophically slow compared to BLAS-backed operations.

**How to optimize:**

- **Use `np.einsum` for batch operations** (dot products across rows, element-wise products with reduction). It computes in a single C-level pass over contiguous memory.
- **Normalize vectors once, then use dot product for cosine similarity.** Normalizing is O(n) and dot product on normalized vectors equals cosine similarity, avoiding repeated norm computation.
- **For nearest-neighbor search at scale (>50k vectors), use Approximate Nearest Neighbors** (FAISS, Annoy, ScaNN). Exact brute-force is O(n²); ANN indexes are O(log n) or O(1) amortized.
- **Store vectors as contiguous `np.ndarray`** (not lists). BLAS operations require contiguous memory to use SIMD instructions.

```python
import numpy as np

# ❌ Python loop: computes one similarity per iteration
similarities = []
for i in range(n):
    sim = np.dot(a[i], b[i]) / (np.linalg.norm(a[i]) * np.linalg.norm(b[i]))
    similarities.append(sim)

# ✅ einsum: batch dot product in one C-level pass
dot = np.einsum("ij,ij->i", a, b)
norm_a = np.linalg.norm(a, axis=1)
norm_b = np.linalg.norm(b, axis=1)
similarities = np.where((norm_a > 0) & (norm_b > 0), dot / (norm_a * norm_b), 0.0)

# ✅ Pre-normalize + dot = cosine (avoids recomputing norms)
a_norm = a / np.linalg.norm(a, axis=1, keepdims=True)
b_norm = b / np.linalg.norm(b, axis=1, keepdims=True)
similarities = np.einsum("ij,ij->i", a_norm, b_norm)

# ✅ ANN for large-scale search (O(log n) vs O(n²))
import faiss
index = faiss.IndexFlatIP(dim)
faiss.normalize_L2(vectors)
index.add(vectors)
distances, indices = index.search(query, k=10)

# ✅ Binary format for fast load/save of arrays
np.save("vectors.npy", vectors)
vectors = np.load("vectors.npy")
```

### 8. Compact Data Types

**When it matters:** Whenever your DataFrame uses more memory than necessary for the information it holds. The default `float64` and `int64` types use 8 bytes per value regardless of the actual range. Downcasting to appropriate types can reduce memory 50-90% without information loss.

**How to optimize:**

- **`float32` for bounded metrics** (scores, ratios, percentages in [0,1] or [0,100]). 32-bit precision (~7 significant digits) is more than enough for most analytics. Saves 50% RAM.
- **`pd.Categorical` for low-cardinality string columns** (status, category, label, source). Internally stored as integer codes + a small dictionary. Saves ~90% RAM for columns with < 100 distinct values.
- **`int16` or `int32` for bounded counts** (word counts, page views, sequence indices). If max value < 32,767, `int16` uses 2 bytes vs 8 for `int64` (75% savings).
- **Apply downcasting after all transformations** — avoid casting back and forth during intermediate steps.

```python
# Float downcasting: 50% savings for normalized metrics
float_cols = ["score", "ratio", "similarity", "confidence"]
for col in float_cols:
    df[col] = df[col].astype("float32")

# Categorical: ~90% savings for low-cardinality strings
cat_cols = ["status", "category", "region", "type"]
for col in cat_cols:
    df[col] = df[col].astype("category")

# Integer downcasting: 75% savings for small counts
int_cols = ["page_views", "word_count", "sequence_idx"]
for col in int_cols:
    df[col] = pd.to_numeric(df[col], downcast="integer")

# Memory estimation for 100k rows × 25 columns:
# Default (all float64/object): ~20-50MB
# After optimization: ~5-10MB
```

### 9. Profiling and Benchmarking

**When it matters:** ALWAYS before optimizing. Amdahl's Law states that the maximum speedup from optimizing a component is limited by the fraction of total time that component represents. Optimizing a step that takes 2% of total runtime can never yield more than 2% improvement regardless of how much faster you make it.

**How to optimize:**

- **Measure wall-clock time per pipeline step** to identify the actual bottleneck. Use `time.perf_counter()` (not `time.time()`) for sub-millisecond precision.
- **Use `%%timeit` in notebooks** for micro-benchmarking individual functions or expressions.
- **Use `memory_profiler`** to identify which functions allocate the most memory — essential for finding the step causing OOM errors.
- **Measure before AND after** every optimization to validate the gain is real and significant.

```python
import time

def timed_step(name: str, fn, *args, **kwargs):
    """Measure execution time and row count of a pipeline step."""
    start = time.perf_counter()
    result = fn(*args, **kwargs)
    elapsed = time.perf_counter() - start
    n = result.shape[0] if hasattr(result, "shape") else len(result)
    print(f"  [{name}] {elapsed:.2f}s | {n:,} rows")
    return result

# Usage: wrap each pipeline step
df_clean = timed_step("clean", clean_data, df_raw)
df_features = timed_step("features", compute_features, df_clean)
df_final = timed_step("aggregate", aggregate, df_features)

# In notebooks:
# %%timeit
# expensive_function(data)

# Memory profiling:
# pip install memory-profiler
# python -m memory_profiler my_pipeline.py

# Line-level profiling:
# pip install line-profiler
# kernprof -l -v my_pipeline.py
```

---

## Anti-Patterns to Avoid

### Row-level iteration

**Why it's bad:** `iterrows()` creates a Python `Series` object for every single row, adding ~100x overhead compared to vectorized operations. The CPU cannot leverage SIMD or cache prefetching because each iteration goes through the Python interpreter.

**What to do instead:** Use column-level operations (arithmetic, `.str` accessor, `np.where`, boolean indexing). If the logic genuinely cannot be vectorized, consider `itertuples()` (namedtuples are cheaper than Series) or move the logic to Cython/Numba.

```python
# ❌ iterrows
for idx, row in df.iterrows():
    result.append(row["price"] * row["qty"])

# ✅ Vectorized
df["total"] = df["price"] * df["qty"]
```

### apply with pure Python lambdas

**Why it's bad:** `apply()` runs a Python function per element/row. It does not vectorize — it's syntactic sugar over a loop. The overhead is especially severe on large DataFrames (millions of rows).

**What to do instead:** Check if the operation can be expressed with pandas built-in methods (`.str`, `.dt`, arithmetic, `np.where`). If the function does complex logic that truly can't be vectorized, consider `numba.jit` or writing a ufunc.

```python
# ❌ apply
df["length"] = df["text"].apply(lambda t: len(t.split()))

# ✅ Vectorized str accessor
df["length"] = df["text"].str.split().str.len()
```

### Chained .assign() calls

**Why it's bad:** Each `.assign()` allocates an entirely new DataFrame (full copy of all columns). Chaining N calls means N full copies, where only 1 is necessary.

**What to do instead:** Pass all new columns as keyword arguments in a single `.assign()` call.

```python
# ❌ 4 copies
df = df.assign(a=1).assign(b=2).assign(c=3).assign(d=4)

# ✅ 1 copy
df = df.assign(a=1, b=2, c=3, d=4)
```

### Vectors stored as Python lists inside DataFrames

**Why it's bad:** A column with dtype `object` containing Python lists scatters each list across the heap. There's no memory contiguity, so NumPy/BLAS operations cannot be applied, and every access incurs pointer indirection and Python object overhead.

**What to do instead:** Store vectors externally as a contiguous `np.ndarray` with shape `(n, dim)`. Reference by index if you need to associate with DataFrame rows.

```python
# ❌ Scattered heap objects
df["vector"] = df["text"].apply(lambda t: encode(t).tolist())

# ✅ Contiguous array, separate from DataFrame
vectors = np.stack([encode(t) for t in df["text"]], dtype=np.float32)
```

### Oversized data types

**Why it's bad:** Default `float64` uses 8 bytes per value and `int64` uses 8 bytes per value. For normalized metrics in [0,1], `float64` provides 15 digits of precision when 7 suffices. For counts under 1000, `int64` uses 4x more memory than needed. This directly impacts cache utilization and memory bandwidth.

**What to do instead:** Downcast after all transformations are complete. Use `float32` for bounded metrics, `int16`/`int32` for small counts, and `pd.Categorical` for low-cardinality strings.

```python
# ❌ Defaults waste memory
# float64 for scores [0,1] → 8 bytes (needs only 4)
# int64 for counts [0,200] → 8 bytes (needs only 2)

# ✅ Right-sized types
df["score"] = df["score"].astype("float32")       # 50% savings
df["count"] = df["count"].astype("int16")          # 75% savings
df["category"] = df["category"].astype("category") # ~90% savings
```

### Reading entire files when you need a subset

**Why it's bad:** Reading all columns from a Parquet file when you only need 2-3 of them multiplies I/O and memory usage by the ratio of total columns to needed columns. For a 30-column file where you need 3, you're doing 10x unnecessary I/O.

**What to do instead:** Always specify `columns=` when reading Parquet. Use `filters=` for row-level predicate pushdown on partitioned datasets.

```python
# ❌ Reads all 30 columns, then discards 28
df = pd.read_parquet("data.parquet")
subset = df[["id", "date"]]

# ✅ Reads only 2 columns from disk
subset = pd.read_parquet("data.parquet", columns=["id", "date"])
```

---

## Rules for the Agent

### When optimizing performance:

1. **Profile first** — never optimize without measuring the real bottleneck
2. **Vectorize** — `str.contains()`, `np.einsum`, `np.where` > Python loops
3. **Parallelize independent operations** — ThreadPool for I/O, ProcessPool for CPU
4. **Reduce allocations** — consolidate masks, batch assign, enable CoW
5. **Downcast types** — float32 for metrics, int16 for small counts, Categorical for enums
6. **Column pruning** — read only necessary columns from parquets
7. **Release memory early** — `del` + `gc.collect()` between pipeline steps
8. **Store embeddings as ndarray** — never as object column with lists

### Decision hierarchy:

| Conflict | Priority |
|----------|----------|
| Purity vs Performance | HPC within function scope; purity at the interface |
| Immutability vs Memory | CoW resolves both; `del` + `gc.collect()` between steps |
| Readability vs Vectorization | Vectorize with clear docstring; keep readable version commented |
| Parallelism vs Simplicity | Parallelize only what profiling showed as bottleneck |

### When to apply each technique:

| Data Size | Recommended Approach |
|-----------|---------------------|
| < 10k rows | Vectorized pandas is sufficient |
| 10k - 1M rows | + compact types, column pruning, batch assign |
| 1M - 10M rows | + chunked processing, parallelism, Polars lazy |
| > 10M rows | + partitioned parquet, Spark/Dask, ANN for search |
