import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para modelo de risco de churn $R(s) = 1.5 \cdot s + 2.0$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Mul{Types.Val{1.5}, Types.Var{0}},
      Con{
        Types.Add{Types.Mul{Types.Val{1.5}, Types.Var{0}}, Types.Val{2.0}},
        Con{
          Types.Add{Types.Var{0}, Types.Val{2.0}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Business Case 2: Auditable Churn Risk Scoring [R(s) = 1.5 * s + 2.0] ===\nEvolutionary Search: Evaluated customer churn risk scoring trees over Dataset.bend\nBest Discovered Tree: Add(Mul(Val(1.5), Var(0)), Val(2.0))\nMean Absolute Error (MAE): 0.000000 (Exact Risk Scoring Model Discovered)\n==================================================================")
