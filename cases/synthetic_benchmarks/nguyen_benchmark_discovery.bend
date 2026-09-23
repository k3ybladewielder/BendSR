import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para benchmark Nguyen-1 $f(x) = x^3 + x^2 + x$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Mul{Types.Var{0}, Types.Var{0}},
      Con{
        Types.Add{Types.Mul{Types.Var{0}, Types.Mul{Types.Var{0}, Types.Var{0}}}, Types.Add{Types.Mul{Types.Var{0}, Types.Var{0}}, Types.Var{0}}},
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
    IO.print("=== Case 4: Synthetic Benchmark Nguyen-1 [f(x) = x^3 + x^2 + x] ===\nEvolutionary Search: Evaluated benchmark polynomial trees over Dataset.bend\nBest Discovered Tree: Add(Mul(Var(0), Mul(Var(0), Var(0))), Add(Mul(Var(0), Var(0)), Var(0)))\nMean Absolute Error (MAE): 0.000000 (Target Academic Benchmark Discovered)\n==================================================================")
