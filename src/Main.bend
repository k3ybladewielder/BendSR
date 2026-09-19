import Base
import Types
import Engine

# Constrói uma população inicial de árvores simples
def init_population() -> List<Types.Expr>:
  p0 = Types.Expr/Add { left: Types.Expr/Var, right: Types.Expr/Val { val: 1.0 } }
  p1 = Types.Expr/Mul { left: Types.Expr/Var, right: Types.Expr/Var }
  p2 = Types.Expr/Sin { arg: Types.Expr/Var }
  p3 = Types.Expr/Val { val: 2.0 }
  List/Cons { head: p0, tail: List/Cons { head: p1, tail: List/Cons { head: p2, tail: List/Cons { head: p3, tail: List/Nil } } } }

def main() -> IO(Unit):
  do IO<Unit>:
    # Conjunto de dados de treino: y = x^2 + 1 para x em [0, 1, 2, 3]
    dataset = List/Cons { 
      head: (0.0, 1.0), 
      tail: List/Cons { 
        head: (1.0, 2.0), 
        tail: List/Cons { 
          head: (2.0, 5.0), 
          tail: List/Cons { 
            head: (3.0, 10.0), 
            tail: List/Nil 
          } 
        } 
      } 
    }
    
    initial_pop = init_population()
    
    # Executa 10 gerações paralelas para 4 indivíduos
    _results = Engine.evolve!(initial_pop, dataset, 4u, 10n, 42u)
    
    IO.print("Regressao Simbolica executada com sucesso.")
