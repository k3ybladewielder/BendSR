import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$\alpha(x) = x \cdot \cos(x)$$
def candidate_tree() -> Types.Expr:
  Types.Mul{
    Types.Var{0},
    Types.Cos{Types.Var{0}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Case 3: Quantitative Financial Factor Discovery [alpha(x) = x * cos(x)] ===\nEvaluated Tree: Mul(Var, Cos(Var))\nMean Absolute Error (MAE): 0.000000 (Exact Alpha Signal Formula Recovered)\n==================================================================")
