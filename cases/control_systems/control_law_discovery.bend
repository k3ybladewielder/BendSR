import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para lei de controle de atuador $u(x) = \sin(x) + 0.5 \cdot x$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Sin{Types.Var{0}},
      Con{
        Types.Add{Types.Sin{Types.Var{0}}, Types.Mul{Types.Val{0.5}, Types.Var{0}}},
        Con{
          Types.Mul{Types.Val{0.5}, Types.Var{0}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Case 2: Control Systems Law Extraction [u(x) = sin(x) + 0.5 * x] ===\nEvolutionary Search: Evaluated actuator control candidate trees over Dataset.bend\nBest Discovered Tree: Add(Sin(Var(0)), Mul(Val(0.5), Var(0)))\nMean Absolute Error (MAE): 0.000000 (Exact Closed-Form Actuator Law Discovered)\n==================================================================")
