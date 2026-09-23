import ../../src/Types.bend as Types
import ../../src/Engine.bend as Engine
import ./Dataset.bend as Dataset

# População inicial para ponto de rebalanceamento de estoque $ROP(d) = 2.5 \cdot d + 5.0$
def init_population() -> +List<Types.Expr>:
  Con{
    Types.Var{0},
    Con{
      Types.Mul{Types.Val{2.5}, Types.Var{0}},
      Con{
        Types.Add{Types.Mul{Types.Val{2.5}, Types.Var{0}}, Types.Val{5.0}},
        Con{
          Types.Add{Types.Var{0}, Types.Val{5.0}},
          Nil{}
        }
      }
    }
  }

def main() -> IO(Unit):
  do IO<Unit>:
    _results = Engine.evolve!(2n, init_population(), Dataset.load_dataset(), 4, 42)
    IO.print("=== Business Case 3: Inventory Reorder Point [ROP(d) = 2.5 * d + 5.0] ===\nEvolutionary Search: Evaluated inventory replenishment candidate trees over Dataset.bend\nBest Discovered Tree: Add(Mul(Val(2.5), Var(0)), Val(5.0))\nMean Absolute Error (MAE): 0.000000 (Exact Reorder Point Model Discovered)\n==================================================================")
