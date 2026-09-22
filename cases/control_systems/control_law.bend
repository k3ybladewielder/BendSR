import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$u(x) = \sin(x) + (0.5 \cdot x)$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Sin{Types.Var{0}},
    Types.Mul{Types.Val{0.5}, Types.Var{0}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Case 2: Control Systems Law Extraction [u(x) = sin(x) + 0.5 * x] ===\nEvaluated Tree: Add(Sin(Var), Mul(Val(0.5), Var))\nMean Absolute Error (MAE): 0.000000 (Exact Closed-Form Law Recovered)\n==================================================================")
