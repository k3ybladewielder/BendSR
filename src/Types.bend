import Base

# Ponto de treino dinâmico multivariável (xs = [x0, x1, ...], y = target)
type Point is Data:
  Pt{xs: List<F32>, y: F32}

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
