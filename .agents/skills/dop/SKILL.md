---
name: dop
description: Data-Oriented Programming paradigm for data pipelines. Guides code structure around pure transformations of immutable data with explicit schemas, separation of data from logic, and pipeline composition. Use when building data pipelines, analytics code, or processing tabular data with pandas/numpy.
keywords: ["dop", "data-oriented", "pipeline", "immutable", "pure-functions", "schema", "pandas", "dataframe", "transformations", "analytics", "data-pipeline"]
---

# Data-Oriented Programming (DOP)

## What It Is

Data-Oriented Programming is a paradigm where data is a first-class citizen. Code is organized around immutable data transformations, with clear separation between data and logic. Instead of encapsulating data in objects with methods, you work with generic data structures (dicts, lists, DataFrames) and pure functions that transform those structures.

DOP is ideal for analytics pipelines and data processing workflows.

---

## Core Principles

### 1. Separate Data from Logic
- Data lives in generic structures (dict, list, DataFrame, Series)
- Logic lives in pure functions that receive and return data
- Never mix mutable state with behavior

### 2. Data is Immutable
- Never modify data in-place
- Each transformation returns a NEW structure
- Use `.assign()`, `pd.concat()` instead of mutation

### 3. Data has Explicit Schema
- Define the expected format of data (columns, types, constraints)
- Validate at the entry of each function/pipeline
- Document schemas as contracts

### 4. Functions are Pure
- Same input → same output (deterministic)
- No side effects (does not alter external state)
- No dependency on global state

### 5. Pipeline as Composition of Transformations
- Each step is a pure function: `data_in → data_out`
- The pipeline is the sequential composition of these functions
- Each intermediate step is inspectable and testable

---

### Separation of Data vs Logic (Directory Structure)

```
src/
├── domain/          # PURE DATA (schemas, constants, enums)
│   ├── schema.py    # BRONZE_SCHEMA, SILVER_SCHEMA, GOLD_SCHEMA
│   ├── constants.py # thresholds, regex patterns, mappings
│   └── types.py     # type aliases, TypedDicts
├── transformations/ # PURE LOGIC (functions without side effects)
│   ├── cleaning.py      # remove_nulls(), normalize(), deduplicate()
│   ├── features.py      # compute_metrics(), add_derived_columns()
│   ├── aggregation.py   # daily_summary(), group_by_user()
│   └── validation.py    # validate_schema(), check_invariants()
└── effects/         # EFFECTS (I/O, API calls, external state)
    ├── io.py            # read_parquet(), save_parquet(), read_csv()
    ├── api.py           # fetch_from_api(), post_results()
    └── database.py      # query_table(), upsert_records()
```

**Principle**: `domain/` and `transformations/` never do I/O.
`effects/` is the only place with side effects (read/write disk, call APIs, query databases).

---

## Rules for the Agent

### When working with data:

1. **Never mutate DataFrames** — use `.assign()`, `.pipe()`, `.copy()`
2. **Always define schemas** — document expected columns in the docstring
3. **Validate at entry** — check columns and types before processing
4. **Pure functions** — no side effects, no global state
5. **Pipeline as composition** — use `.pipe()` to chain transformations
6. **Name transformations** — each `.pipe(fn)` should have a descriptive name
7. **Release memory** — `del df; gc.collect()` after large intermediate DataFrames
8. **Batch assign** — group multiple columns in a single `.assign()` call

### When designing pipelines:

1. **Clear layers** — bronze → silver → gold
2. **Each step testable in isolation**
3. **Intermediate data inspectable** (save parquet between steps)
4. **Explicit errors** — fail early with clear message
5. **Progress bars** — use tqdm for long operations
6. **Logging** — record input/output counts at each step
7. **Checkpoints** — for expensive operations (embeddings), save incremental progress
8. **Deduplication** — compare with existing gold before reprocessing

### When writing tests:

1. **Prefer property-based tests** for data transformations
2. **Test properties, not examples** — "output always has N columns" > "input X gives output Y"
3. **Use custom strategies** to generate realistic data
4. **Test schemas** — output always follows the contract
5. **Test invariants** — metrics in range, counts preserved, no unexpected NaN
6. **Test idempotency** — cleaning applied 2x = 1x
