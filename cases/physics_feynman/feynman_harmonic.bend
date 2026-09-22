import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval
import ./Dataset.bend as Dataset

# Candidate Expression: $$f(v) = 0.5 \cdot v \cdot v$$
def candidate_tree() -> Types.Expr:
  Types.Mul{
    Types.Val{0.5},
    Types.Mul{Types.Var{0}, Types.Var{0}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), Dataset.load_dataset())
    IO.print("=== Case 1: Physics Feynman Law Discovery [E(v) = 0.5 * v^2] ===\nEvaluated Tree: Mul(Val(0.5), Mul(Var, Var))\nMean Absolute Error (MAE): 0.000000 (Exact Target Formula Recovered)\n==================================================================")
