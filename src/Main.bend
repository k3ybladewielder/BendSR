import Base
import ./Types.bend as Types
import ./Engine.bend as Engine

# Constrói uma população inicial de árvores simples
def init_population() -> +List<Types.Expr>:
  Con{ 
    Types.Add{Types.Var{0}, Types.Val{1.0}}, 
    Con{ 
      Types.Mul{Types.Var{0}, Types.Var{0}}, 
      Con{ 
        Types.Sin{Types.Var{0}}, 
        Con{ 
          Types.Val{2.0}, 
          Nil{} 
        } 
      } 
    } 
  }

# Constrói o dataset de treino
def make_dataset() -> +List<Types.Point>:
  Con{ 
    Types.Pt{Con{0.0, Nil{}}, 1.0}, 
    Con{ 
      Types.Pt{Con{1.0, Nil{}}, 2.0}, 
      Con{ 
        Types.Pt{Con{2.0, Nil{}}, 5.0}, 
        Con{ 
          Types.Pt{Con{3.0, Nil{}}, 10.0}, 
          Nil{} 
        } 
      } 
    } 
  }

def run_evolution(+dataset: +List<Types.Point>, +initial_pop: +List<Types.Expr>) -> IO(Unit):
  do IO<Unit>:
    # Executa 10 gerações paralelas para 4 indivíduos
    _results = Engine.evolve!(10n, initial_pop, dataset, 4, 42)
    IO.print("Symbolic regression successfully executed.")

def main() -> IO(Unit):
  run_evolution(make_dataset(), init_population())
