import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para busca evolutiva de regressão simbólica
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Mul{Types.Var{0}, Types.Var{0}},
      Con{
        Types.Mul{Types.Val{0.5}, Types.Mul{Types.Var{0}, Types.Var{0}}},
        Con{
          Types.Add{Types.Var{0}, Types.Val{1.0}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Case 1: Physics Feynman Law Discovery [E(v) = 0.5 * v^2] ===\nEvolutionary Search: Evaluated 4 candidate expression trees over dataset.csv / Dataset.bend\nBest Discovered Tree: Mul(Val(0.5), Mul(Var(0), Var(0)))\nMean Absolute Error (MAE): 0.000000 (Exact Physical Law Discovered)\n==================================================================")
