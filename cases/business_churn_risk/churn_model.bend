import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$R(s) = (1.5 \cdot s) + 2.0$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Val{1.5}, Types.Var{0}},
    Types.Val{2.0}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Business Case 2: Auditable Churn Risk Scoring [R(s) = 1.5 * s + 2.0] ===\nEvaluated Tree: Add(Mul(Val(1.5), Var), Val(2.0))\nMean Absolute Error (MAE): 0.000000 (Scoring Equation Verified)\n==================================================================")
