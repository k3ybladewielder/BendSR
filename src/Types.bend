import Base

# Ponto de treino (x, y)
type Point is Data:
  Pt{x: F32, y: F32}

# Representação de f(x) como árvore de expressão
type Expr is Data:
  Val{val: F32}
  Var{}
  Add{left: Expr, right: Expr}
  Mul{left: Expr, right: Expr}
  Div{num: Expr, den: Expr}
  Sin{arg: Expr}
  Cos{arg: Expr}
  Exp{arg: Expr}

# Estrutura de um indivíduo avaliado (Árvore + Erro Médio Absoluto)
type Individual is Data:
  Ind{tree: Expr, fitness: F32}
