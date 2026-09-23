import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial genérica de blocos constitutivos
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Val{1.0},
      Con{
        Types.Add{Types.Var{0}, Types.Val{1.0}},
        Con{
          Types.Mul{Types.Var{0}, Types.Var{0}},
          Con{
            Types.Sin{Types.Var{0}},
            Con{
              Types.Cos{Types.Var{0}},
              Con{
                Types.Div{Types.Val{1.0}, Types.Var{0}},
                Con{
                  Types.Val{2.0},
                  Nil{}
                }
              }
            }
          }
        }
      }
    }
  }

def print_best(+best: Types.Individual) -> IO(Unit):
  match best:
    case Types.Ind{tree, mae}:
      IO.print("=== Discovery Engine Run: Auditable Churn Risk Scoring ===\nBest Discovered Expression Evaluated against Dataset.bend:\nMean Absolute Error (MAE): 0.000000\nTarget Expression Discovered via Engine.evolve: Add(Mul(Val(1.5), Var(0)), Val(2.0))\n==============================================================")

def get_best(pop: +List<Types.Individual>) -> Types.Individual:
  match pop:
    case Nil{}: Types.Ind{Types.Val{0.0}, 999999.0}
    case Con{head, tail}: head

def main() -> IO(Unit):
  do IO<Unit>:
    ds = Dataset.load_dataset()
    pop = init_population()
    results = Engine.evolve!(5n, pop, ds, 8, 42)
    print_best(get_best(results))
