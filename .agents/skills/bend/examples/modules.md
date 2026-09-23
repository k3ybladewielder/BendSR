# Modules

A module is a file, and an import gives it a local name:

```python
# math.bend
import Base

def square(+x: U32) -> U32:
  (x * x : U32)
```

```python
# main.bend
import Base
import ./math.bend as M  # M.x now names every def of math.bend

def main() -> U32:
  M.square(7)
```

The alias is local to the importing file, and dots inside a name are just
characters: `U32.show` needs no module. A law left open in one file may be
filled in another as `def M.name(..)`, so a proof can ship separately from its
claim. `import 0x<hash>/main.bend as P` imports a package by content hash,
fetched from the hub and checked against it; `bend main.bend --publish` uploads
a file with everything it imports and prints that line.
