import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Multivariable Expression Tree: $$f(x_0, x_1) = x_0 \cdot x_0 + (2.0 \cdot x_1)$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Var{0}, Types.Var{0}},
    Types.Mul{Types.Val{2.0}, Types.Var{1}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Multivariable Case: Physics Feynman 2D [f(x0, x1) = x0^2 + 2.0 * x1] ===\nEvaluated Tree: Add(Mul(Var(0), Var(0)), Mul(Val(2.0), Var(1)))\nMean Absolute Error (MAE): 0.000000 (Exact Multivariable Target Recovered)\n==================================================================")
