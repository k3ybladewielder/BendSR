# LAWS.bend
import Base
import ./Types.bend as T
import ./Eval.bend as E

# Garantia de determinismo e imutabilidade na avaliação de expressões
law safe_tree_evaluation:
  for +expr: T.Expr
  for +vars: T.FList
  {E.eval(expr, vars) == E.eval(expr, vars) : F32}
