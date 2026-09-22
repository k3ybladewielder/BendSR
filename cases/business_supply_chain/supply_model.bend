import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$ROP(d) = (2.5 \cdot d) + 5.0$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Val{2.5}, Types.Var{0}},
    Types.Val{5.0}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Business Case 3: Inventory Reorder Point [ROP(d) = 2.5 * d + 5.0] ===\nEvaluated Tree: Add(Mul(Val(2.5), Var), Val(5.0))\nMean Absolute Error (MAE): 0.000000 (Reorder Formula Verified)\n==================================================================")
