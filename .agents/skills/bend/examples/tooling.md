# Tooling

Bend is a single command:

```bash
bend file.bend            # check; run main (IO compiled; a value normalized)
bend file.bend -o file    # compile to a native binary (clang 14+; 19+ with `!`)
bend file.bend -o file.c  # emit the C source instead
bend file.bend -o file.js # emit the JS source instead
bend page.html -o dist    # bundle a web page that imports .bend files
./file --threads 8        # run a native binary on 8 CPU threads
./file --gpu off          # run ! calls on the CPU (the GPU is on by default)
./file --gpu 4GB          # cap the GPU's heap at 4GB
```

A `main` that returns `IO` runs compiled; one that returns a value is normalized
by the checker (slow for big work) and printed; a file with no `main` just
checks. A binary that uses `!` builds its GPU program too, as `file.gpu`, which
must stay beside it: on macOS it needs Metal, on Linux CUDA 12 at
`/usr/local/cuda`. On Linux a program with a Window needs `libx11-dev`, one
with Audio `libasound2-dev`. `bend guide` prints this text, `bend base` prints
the Base library (`bend base Map` prints one name and everything under it), and
`bend --help` lists the other commands.
