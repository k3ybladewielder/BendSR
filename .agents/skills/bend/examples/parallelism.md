# Parallelism

Bend's parallelism primitive is the parallel call notation:

```python
import Base

def pow2(+n: Nat) -> U32:
  match n:
    case 0n:
      1
    case 1n+p:
      a b = pow2(p) pow2(p) # parallel call
      (a + b : U32)

def main() -> IO(Unit):
  IO.print(U32.show(pow2!(20n))) # `!` runs on GPU
```

A parallel call promises the compiler two things:

1. The calls are independent.

2. They run in roughly the same time.

Since Bend is pure and affine, the first point always holds. The second is yours
to keep: if one call finishes before the other, the speedup will be sub-ideal.
Bend's current scheduler is a contention-free, binary fork-join machine: every
task is handed to a core exactly once and never moved afterwards. That makes it
fast and GPU-friendly, but you must keep the workload balanced.

A `!` after a function name marks a parallel call: `pow2!(20n)` hands that call,
and every parallel call inside it, to the GPU. When compiled to a native
executable, `pow2(20n)` runs in parallel on the CPU, while `pow2!(20n)` runs on
the GPU. The heap is fully unified, so, if your chip
has unified memory (as in Apple M-series processors), moving data from the CPU
to the GPU is a zero-cost operation. The GPU shines on uniform numeric work like
mandelbrot or nbody; divergent work like n-queens stays faster on the CPU. A
machine without a GPU runs `!` on the CPU (still in parallel). What the lanes
share also sets the speed: a `+` value read by every lane costs an atomic per
read. Read `bend guide shaders` before you write a parallel app.

The JavaScript target ignores all that and just runs sequentially.
