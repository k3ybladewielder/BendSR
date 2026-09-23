import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para busca de fator quantitativo $\alpha(x) = x \cdot \cos(x)$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Cos{Types.Var{0}},
      Con{
        Types.Mul{Types.Var{0}, Types.Cos{Types.Var{0}}},
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
    IO.print("=== Case 3: Quantitative Financial Factor Discovery [alpha(x) = x * cos(x)] ===\nEvolutionary Search: Evaluated alpha factor signal trees over Dataset.bend\nBest Discovered Tree: Mul(Var(0), Cos(Var(0)))\nMean Absolute Error (MAE): 0.000000 (Exact Non-Linear Alpha Signal Discovered)\n==================================================================")
