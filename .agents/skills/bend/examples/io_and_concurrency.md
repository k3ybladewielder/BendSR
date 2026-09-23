# IO and Concurrency

Effects live in the `IO` type and are sequenced with `do` blocks:

```python
import Base

def greet(name: String) -> IO(String):
  do IO<String>:
    IO.sleep(1000)             # a step
    return "Hello, " ++ name   # return: wraps a pure value

def main() -> IO(Unit):
  do IO<Unit>:
    name : String <- IO.try(String, IO.get_env("USER")) # <-: binds a result
    chan : Chan(String) <- IO.fork(String, greet(name)) # runs concurrently
    IO.print("Waiting...")
    text : String <- IO.join(String, chan)
    IO.print(text)
```

Every bind is annotated, and `x : T = v` binds a pure value in the middle of a
block. A fallible effect answers `Result<&1, &1, U32 & String, A>`: `IO.try`
unwraps it or exits with the error, and `IO.die` exits with your own. `IO.args`
answers the command line, less the runtime's own options (a `--` ends them). A
handle (`File`, `Socket`, `Window`) is an affine, opaque value, so every effect
on one hands it back beside its result, and no program can forge or reuse one.

A Bend program is a set of computations interleaved by one event loop, as in
Node.js: each runs its pure code (in parallel, on every core) up to its next
effect, and one that waits on a socket, a sleep or a channel steps aside for the
others. `IO.fork` starts a computation and returns the channel its result will
arrive on; `IO.join` waits for it. Underneath are `IO.spawn`, `Chan.new`,
`Chan.send`, `Chan.recv` and `Chan.close`. The program ends when every
computation is done, or reports a deadlock when the remaining ones all wait.

Every effect in Base is a def whose body is `import "./x.js"` plus a `.c` twin,
implemented by a host function named after the def, lowercased, dots to
underscores. You can add your own effects the same way. Only the event loop runs
them, so proofs, termination and the GPU never touch host code. In the other
direction, a JS file may `import Game from "./game.bend"` (with `bend2/main.ts`
preloaded) and call every non-IO def, with constructors as `{$: "Name", field:
value}` and `Nat` as `BigInt`. A value crosses without a copy: an `Array`
argument is the caller's own array, updated in place, so copy it first if you
keep it.
