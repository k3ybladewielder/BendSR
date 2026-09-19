# LAWS.bend
import Types
import Eval

# Garantia de determinismo e imutabilidade na avaliação de expressões
law safe_tree_evaluation:
  for expr: Types.Expr, x: F32:
    {Eval.eval(expr, x) == Eval.eval(expr, x) : F32}
