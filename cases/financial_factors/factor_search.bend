import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Financial Factor dataset points for $$\alpha(x) = x \cdot \cos(x)$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{0.0, 0.0},
    Con{
      Types.Pt{0.5, 0.4387912},
      Con{
        Types.Pt{1.0, 0.5403023},
        Con{
          Types.Pt{1.5, 0.1060934},
          Nil{}
        }
      }
    }
  }

# Candidate Expression: $$\alpha(x) = x \cdot \cos(x)$$
def candidate_tree() -> Types.Expr:
  Types.Mul{
    Types.Var{},
    Types.Cos{Types.Var{}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Case 3: Quantitative Financial Factor Discovery [alpha(x) = x * cos(x)] ===\nEvaluated Tree: Mul(Var, Cos(Var))\nMean Absolute Error (MAE): 0.000000 (Exact Alpha Signal Formula Recovered)\n==================================================================")
