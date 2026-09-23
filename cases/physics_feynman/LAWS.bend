import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Formal law asserting deterministic evaluation of Feynman kinetic energy candidate trees
law physics_feynman_evaluation_determinism:
  for +tree: Types.Expr
  {Eval.compute_mae(tree, Dataset.load_dataset()) == Eval.compute_mae(tree, Dataset.load_dataset()) : F32}
