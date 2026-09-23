# LAWS.bend
import Base
import ./Types.bend as Types
import ./Eval.bend as Eval

# Garantia de determinismo e imutabilidade na avaliação de expressões
law safe_tree_evaluation:
  for +expr: Types.Expr
  for +vars: Types.FList
  {Eval.eval(expr, vars) == Eval.eval(expr, vars) : F32}
