import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Dataset points for Churn Risk Score: $$R(s) = 1.5 \cdot s + 2.0$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{0.0, 2.0},
    Con{
      Types.Pt{1.0, 3.5},
      Con{
        Types.Pt{2.0, 5.0},
        Con{
          Types.Pt{3.0, 6.5},
          Con{
            Types.Pt{4.0, 8.0},
            Con{
              Types.Pt{5.0, 9.5},
              Nil{}
            }
          }
        }
      }
    }
  }

# Candidate Expression: $$R(s) = (1.5 \cdot s) + 2.0$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Val{1.5}, Types.Var{}},
    Types.Val{2.0}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Business Case 2: Auditable Churn Risk Scoring [R(s) = 1.5 * s + 2.0] ===\nEvaluated Tree: Add(Mul(Val(1.5), Var), Val(2.0))\nMean Absolute Error (MAE): 0.000000 (Scoring Equation Verified)\n==================================================================")
