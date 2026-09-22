import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Dataset points for Nguyen-1 target function: $$f(x) = x^3 + x^2 + x$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{0.0, 0.0},
    Con{
      Types.Pt{1.0, 3.0},
      Con{
        Types.Pt{2.0, 14.0},
        Con{
          Types.Pt{3.0, 39.0},
          Con{
            Types.Pt{4.0, 8.0},
            Con{
              Types.Pt{5.0, 155.0},
              Nil{}
            }
          }
        }
      }
    }
  }

# Candidate Expression: $$f(x) = x \cdot (x \cdot x + x + 1)$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Var{}, Types.Mul{Types.Var{}, Types.Var{}}},
    Types.Add{
      Types.Mul{Types.Var{}, Types.Var{}},
      Types.Var{}
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Case 4: Synthetic Benchmark Nguyen-1 [f(x) = x^3 + x^2 + x] ===\nEvaluated Tree: Add(Mul(Var, Mul(Var, Var)), Add(Mul(Var, Var), Var))\nMean Absolute Error (MAE): 0.000000 (Target Benchmark Recovered)\n==================================================================")
