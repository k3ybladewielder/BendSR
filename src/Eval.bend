import Base
import ./Types.bend as T

# Busca o valor da variável de índice `idx` na lista de variáveis (vars = [x0, x1, x2, ...])
def get_var(+idx: U32, +vars: T.FList) -> F32:
  match idx:
    case 0:
      match vars:
        case T.FNil{}: 0.0
        case T.FCon{head, tail}: head
    case +p:
      match vars:
        case T.FNil{}: 0.0
        case T.FCon{head, +tail}: get_var!(p, tail)

# Helper para decisão de divisão por zero (inspeciona o parâmetro is_zero)
def safe_div_help(is_zero: Bool, num: F32, den: F32) -> F32:
  match is_zero:
    case True{}: 1.0
    case False{}: F32.div(num, den)

# Divisão segura para evitar exceções numéricas
def safe_div(num: F32, +den: F32) -> F32:
  safe_div_help(F32.is_eq(den, 0.0), num, den)

# Avaliação recursiva de f(x0, x1, ...)
def eval(+expr: T.Expr, +vars: T.FList) -> F32:
  match expr:
    case T.Val{val}: val
    case T.Var{idx}: get_var(idx, vars)
    case T.Add{left, right}: F32.add(eval(left, vars), eval(right, vars))
    case T.Mul{left, right}: F32.mul(eval(left, vars), eval(right, vars))
    case T.Div{num, den}: safe_div(eval(num, vars), eval(den, vars))
    case T.Sin{arg}: F32.sin(eval(arg, vars))
    case T.Cos{arg}: F32.cos(eval(arg, vars))
    case T.Exp{arg}: F32.exp(eval(arg, vars))

# Helper para o erro absoluto (inspeciona o parâmetro is_neg)
def point_error_help(is_neg: Bool, diff: F32) -> F32:
  match is_neg:
    case True{}: F32.sub(0.0, diff)
    case False{}: diff

# Cálculo do erro absoluto em um único ponto multivariável |f(vars) - y|
def point_error(+expr: T.Expr, +vars: T.FList, y: F32) -> F32:
  +diff = F32.sub(eval(expr, vars), y)
  point_error_help(F32.is_lt(diff, 0.0), diff)

# Avaliação paralela do erro acumulado no conjunto de dados
def compute_mae(+expr: T.Expr, +points: +List<T.Point>) -> F32:
  match points:
    case Nil{}: 0.0
    case Con{head, +tail}:
      match head:
        case T.Pt{xs, py}:
          head_err = point_error(expr, xs, py)
          tail_err = compute_mae!(expr, tail)
          F32.add(head_err, tail_err)
