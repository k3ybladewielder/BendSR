import Base
import ./Types.bend as T
import ./Engine.bend as Eng

# Constrói uma população inicial de árvores simples
def init_population() -> +List<T.Expr>:
  Con{ 
    T.Add{T.Var{0}, T.Val{1.0}}, 
    Con{ 
      T.Mul{T.Var{0}, T.Var{0}}, 
      Con{ 
        T.Sin{T.Var{0}}, 
        Con{ 
          T.Val{2.0}, 
          Nil{} 
        } 
      } 
    } 
  }

# Constrói o dataset de treino
def make_dataset() -> +List<T.Point>:
  Con{ 
    T.Pt{T.FCon{0.0, T.FNil{}}, 1.0}, 
    Con{ 
      T.Pt{T.FCon{1.0, T.FNil{}}, 2.0}, 
      Con{ 
        T.Pt{T.FCon{2.0, T.FNil{}}, 5.0}, 
        Con{ 
          T.Pt{T.FCon{3.0, T.FNil{}}, 10.0}, 
          Nil{} 
        } 
      } 
    } 
  }

def run_evolution(+dataset: +List<T.Point>, +initial_pop: +List<T.Expr>) -> IO(Unit):
  -results = Eng.evolve!(10n, initial_pop, dataset, 4, 42)
  do IO<Unit>:
    IO.print("Symbolic regression successfully executed.")

def main() -> IO(Unit):
  run_evolution(make_dataset(), init_population())
