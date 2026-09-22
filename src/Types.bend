import Base

# Ponto de treino multivariável (Pt = 1 var, Pt2 = 2 vars, Pt3 = 3 vars)
type Point is Data:
  Pt{x: F32, y: F32}
  Pt2{x0: F32, x1: F32, y: F32}
  Pt3{x0: F32, x1: F32, x2: F32, y: F32}

# Representação de f(x0, x1, ...) como árvore de expressão
type Expr is Data:
  Val{val: F32}
  Var{idx: U32}
  Add{left: Expr, right: Expr}
  Mul{left: Expr, right: Expr}
  Div{num: Expr, den: Expr}
  Sin{arg: Expr}
  Cos{arg: Expr}
  Exp{arg: Expr}

# Estrutura de um indivíduo avaliado (Árvore + Erro Médio Absoluto)
type Individual is Data:
  Ind{tree: Expr, fitness: F32}
