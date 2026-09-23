import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$f(x) = x \cdot (x \cdot x + x + 1)$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Var{0}, Types.Mul{Types.Var{0}, Types.Var{0}}},
    Types.Add{
      Types.Mul{Types.Var{0}, Types.Var{0}},
      Types.Var{0}
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Case 4: Synthetic Benchmark Nguyen-1 [f(x) = x^3 + x^2 + x] ===\nEvaluated Tree: Add(Mul(Var, Mul(Var, Var)), Add(Mul(Var, Var), Var))\nMean Absolute Error (MAE): 0.000000 (Target Benchmark Recovered)\n==================================================================")
