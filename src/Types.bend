import Base

# Representação de f(x) como árvore de expressão
type Expr:
  Val { val: F32 }
  Var
  Add { left: Expr, right: Expr }
  Mul { left: Expr, right: Expr }
  Div { num: Expr, den: Expr }
  Sin { arg: Expr }
  Cos { arg: Expr }
  Exp { arg: Expr }

# Estrutura de um indivíduo avaliado (Árvore + Erro Médio Absoluto)
type Individual:
  Ind { tree: Expr, fitness: F32 }
