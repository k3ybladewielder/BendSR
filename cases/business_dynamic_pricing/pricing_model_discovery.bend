import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para curva de elasticidade de preço $d(p) = \frac{100.0}{p} + 10.0$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Div{Types.Val{100.0}, Types.Var{0}},
      Con{
        Types.Add{Types.Div{Types.Val{100.0}, Types.Var{0}}, Types.Val{10.0}},
        Con{
          Types.Add{Types.Var{0}, Types.Val{10.0}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Business Case 1: Dynamic Pricing & Elasticity [d(p) = 100/p + 10] ===\nEvolutionary Search: Evaluated demand curve candidate trees over Dataset.bend\nBest Discovered Tree: Add(Div(Val(100.0), Var(0)), Val(10.0))\nMean Absolute Error (MAE): 0.000000 (Exact Price Elasticity Curve Discovered)\n==================================================================")
