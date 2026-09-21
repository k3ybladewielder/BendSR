import Base
import ./Types.bend as Types

# Helper para decisão de divisão por zero (inspeciona o parâmetro is_zero)
def safe_div_help(is_zero: Bool, num: F32, den: F32) -> F32:
  match is_zero:
    case True{}: 1.0
    case False{}: F32.div(num, den)

# Divisão segura para evitar exceções numéricas
def safe_div(num: F32, +den: F32) -> F32:
  safe_div_help(F32.is_eq(den, 0.0), num, den)

# Avaliação recursiva de f(x)
def eval(+expr: Types.Expr, +x: F32) -> F32:
  match expr:
    case Types.Val{val}: val
    case Types.Var{}: x
    case Types.Add{left, right}: F32.add(eval(left, x), eval(right, x))
    case Types.Mul{left, right}: F32.mul(eval(left, x), eval(right, x))
    case Types.Div{num, den}: safe_div(eval(num, x), eval(den, x))
    case Types.Sin{arg}: F32.sin(eval(arg, x))
    case Types.Cos{arg}: F32.cos(eval(arg, x))
    case Types.Exp{arg}: F32.exp(eval(arg, x))

# Helper para o erro absoluto (inspeciona o parâmetro is_neg)
def point_error_help(is_neg: Bool, diff: F32) -> F32:
  match is_neg:
    case True{}: F32.sub(0.0, diff)
    case False{}: diff

# Cálculo do erro absoluto em um único ponto |f(x) - y|
def point_error(+expr: Types.Expr, x: F32, y: F32) -> F32:
  +diff = F32.sub(eval(expr, x), y)
  point_error_help(F32.is_lt(diff, 0.0), diff)

# Avaliação paralela do erro acumulado no conjunto de dados
def compute_mae(+expr: Types.Expr, +points: +List<Types.Point>) -> F32:
  match points:
    case Nil{}: 0.0
    case Con{head, tail}:
      match head:
        case Types.Pt{px, py}:
          head_err = point_error(expr, px, py)
          tail_err = compute_mae!(expr, tail)
          F32.add(head_err, tail_err)
