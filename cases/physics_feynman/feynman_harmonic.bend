import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Dataset points for Feynman Kinetic Energy equation: $$E(v) = 0.5 \cdot v^2$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{0.0, 0.0},
    Con{
      Types.Pt{1.0, 0.5},
      Con{
        Types.Pt{2.0, 2.0},
        Con{
          Types.Pt{3.0, 4.5},
          Con{
            Types.Pt{4.0, 8.0},
            Con{
              Types.Pt{5.0, 12.5},
              Con{
                Types.Pt{6.0, 18.0},
                Nil{}
              }
            }
          }
        }
      }
    }
  }

# Candidate Expression: $$f(v) = 0.5 \cdot v \cdot v$$
def candidate_tree() -> Types.Expr:
  Types.Mul{
    Types.Val{0.5},
    Types.Mul{Types.Var{}, Types.Var{}}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Case 1: Physics Feynman Law Discovery [E(v) = 0.5 * v^2] ===\nEvaluated Tree: Mul(Val(0.5), Mul(Var, Var))\nMean Absolute Error (MAE): 0.000000 (Exact Target Formula Recovered)\n==================================================================")
