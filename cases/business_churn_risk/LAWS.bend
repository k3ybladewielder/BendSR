import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Formal law asserting deterministic evaluation of churn risk scoring trees
law churn_risk_evaluation_determinism:
  for +tree: Types.Expr
  {Eval.compute_mae(tree, Dataset.load_dataset()) == Eval.compute_mae(tree, Dataset.load_dataset()) : F32}
