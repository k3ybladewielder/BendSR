import Base
import Types

# Divisão segura para evitar exceções numéricas
def safe_div(num: F32, den: F32) -> F32:
  match (den == 0.0):
    case True: 1.0
    case False: num / den

# Avaliação recursiva de f(x)
def eval(expr: Types.Expr, x: F32) -> F32:
  match expr:
    case Types.Expr/Val: expr.val
    case Types.Expr/Var: x
    case Types.Expr/Add: eval(expr.left, x) + eval(expr.right, x)
    case Types.Expr/Mul: eval(expr.left, x) * eval(expr.right, x)
    case Types.Expr/Div: safe_div(eval(expr.num, x), eval(expr.den, x))
    case Types.Expr/Sin: F32.sin(eval(expr.arg, x))
    case Types.Expr/Cos: F32.cos(eval(expr.arg, x))
    case Types.Expr/Exp: F32.exp(eval(expr.arg, x))

# Cálculo do erro absoluto em um único ponto |f(x) - y|
def point_error(expr: Types.Expr, x: F32, y: F32) -> F32:
  diff = eval(expr, x) - y
  match (diff < 0.0):
    case True: 0.0 - diff
    case False: diff

# Avaliação paralela do erro acumulado no conjunto de dados
def compute_mae(expr: Types.Expr, points: List<(F32, F32)>) -> F32:
  match points:
    case List/Nil: 0.0
    case List/Cons:
      head_err = point_error(expr, points.head.0, points.head.1)
      tail_err = compute_mae!(expr, points.tail)
      head_err + tail_err
