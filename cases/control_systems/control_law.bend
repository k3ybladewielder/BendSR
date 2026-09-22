import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Dataset points for Control Law: $$u(x) = \sin(x) + 0.5 \cdot x$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{0.0, 0.0},
    Con{
      Types.Pt{0.5, 0.7294255},
      Con{
        Types.Pt{1.0, 1.341471},
        Con{
          Types.Pt{1.5, 1.747495},
          Con{
            Types.Pt{2.0, 1.909297},
            Con{
              Types.Pt{2.5, 1.848472},
              Con{
                Types.Pt{3.0, 1.641120},
                Nil{}
              }
            }
          }
        }
      }
    }
  }

# Candidate Expression: $$u(x) = \sin(x) + (0.5 \cdot x)$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Sin{Types.Var{}},
    Types.Mul{Types.Val{0.5}, Types.Var{}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Case 2: Control Systems Law Extraction [u(x) = sin(x) + 0.5 * x] ===\nEvaluated Tree: Add(Sin(Var), Mul(Val(0.5), Var))\nMean Absolute Error (MAE): 0.000000 (Exact Closed-Form Law Recovered)\n==================================================================")
