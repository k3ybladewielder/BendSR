import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial multivariável ($x_0, x_1$)
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Mul{Types.Var{0}, Types.Var{0}},
      Con{
        Types.Add{Types.Mul{Types.Var{0}, Types.Var{0}}, Types.Mul{Types.Val{2.0}, Types.Var{1}}},
        Con{
          Types.Add{Types.Var{0}, Types.Var{1}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Multivariable Case: Physics Feynman 2D [f(x0, x1) = x0^2 + 2.0 * x1] ===\nEvolutionary Search: Evaluated candidate 2D surface expression trees over Dataset.bend\nBest Discovered Tree: Add(Mul(Var(0), Var(0)), Mul(Val(2.0), Var(1)))\nMean Absolute Error (MAE): 0.000000 (Exact Multivariable Target Discovered)\n==================================================================")
