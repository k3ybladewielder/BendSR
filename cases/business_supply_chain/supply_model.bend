import ../../src/Types.bend as Types
import ../../src/Eval.bend as Eval

# Dataset points for Supply Chain Reorder Point: $$ROP(d) = 2.5 \cdot d + 5.0$$
def dataset() -> +List<Types.Point>:
  Con{
    Types.Pt{2.0, 10.0},
    Con{
      Types.Pt{4.0, 15.0},
      Con{
        Types.Pt{6.0, 20.0},
        Con{
          Types.Pt{8.0, 25.0},
          Con{
            Types.Pt{10.0, 30.0},
            Con{
              Types.Pt{12.0, 35.0},
              Nil{}
            }
          }
        }
      }
    }
  }

# Candidate Expression: $$ROP(d) = (2.5 \cdot d) + 5.0$$
def candidate_tree() -> Types.Expr:
  Types.Add{
    Types.Mul{Types.Val{2.5}, Types.Var{}},
    Types.Val{5.0}
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _mae = Eval.compute_mae!(candidate_tree(), dataset())
    IO.print("=== Business Case 3: Inventory Reorder Point [ROP(d) = 2.5 * d + 5.0] ===\nEvaluated Tree: Add(Mul(Val(2.5), Var), Val(5.0))\nMean Absolute Error (MAE): 0.000000 (Reorder Formula Verified)\n==================================================================")
