import Base
import Types

# Mutação de nós da árvore
def mutate(expr: Types.Expr, rng: U32) -> Types.Expr:
  match expr:
    case Types.Expr/Val:
      delta = (F32.to_f32(rng % 21u) - 10.0) / 10.0
      Types.Expr/Val { val: expr.val + delta }
    case Types.Expr/Var:
      match (rng % 2u == 0u):
        case True: Types.Expr/Val { val: F32.to_f32(rng % 10u) }
        case False: Types.Expr/Var
    case Types.Expr/Add:
      match (rng % 3u):
        case 0u: Types.Expr/Mul { left: expr.left, right: expr.right }
        case 1u: Types.Expr/Add { left: mutate(expr.left, rng / 3u), right: expr.right }
        case 2u: Types.Expr/Add { left: expr.left, right: mutate(expr.right, rng / 3u) }
    case Types.Expr/Mul:
      match (rng % 3u):
        case 0u: Types.Expr/Add { left: expr.left, right: expr.right }
        case 1u: Types.Expr/Mul { left: mutate(expr.left, rng / 3u), right: expr.right }
        case 2u: Types.Expr/Mul { left: expr.left, right: mutate(expr.right, rng / 3u) }
    case Types.Expr/Div:
      match (rng % 2u == 0u):
        case True: Types.Expr/Div { num: mutate(expr.num, rng / 2u), den: expr.den }
        case False: Types.Expr/Div { num: expr.num, den: mutate(expr.den, rng / 2u) }
    case Types.Expr/Sin:
      match (rng % 2u == 0u):
        case True: Types.Expr/Cos { arg: expr.arg }
        case False: Types.Expr/Sin { arg: mutate(expr.arg, rng / 2u) }
    case Types.Expr/Cos:
      match (rng % 2u == 0u):
        case True: Types.Expr/Sin { arg: expr.arg }
        case False: Types.Expr/Cos { arg: mutate(expr.arg, rng / 2u) }
    case Types.Expr/Exp:
      Types.Expr/Exp { arg: mutate(expr.arg, rng / 2u) }

# Extração de subárvore navegando por um caminho de bits
def get_subtree(expr: Types.Expr, path: U32) -> Types.Expr:
  match path:
    case 0u: expr
    case +p:
      match expr:
        case Types.Expr/Val: expr
        case Types.Expr/Var: expr
        case Types.Expr/Add:
          match (p % 2u == 0u):
            case True: get_subtree(expr.left, p / 2u)
            case False: get_subtree(expr.right, p / 2u)
        case Types.Expr/Mul:
          match (p % 2u == 0u):
            case True: get_subtree(expr.left, p / 2u)
            case False: get_subtree(expr.right, p / 2u)
        case Types.Expr/Div:
          match (p % 2u == 0u):
            case True: get_subtree(expr.num, p / 2u)
            case False: get_subtree(expr.den, p / 2u)
        case Types.Expr/Sin: get_subtree(expr.arg, p / 2u)
        case Types.Expr/Cos: get_subtree(expr.arg, p / 2u)
        case Types.Expr/Exp: get_subtree(expr.arg, p / 2u)

# Substituição de subárvore
def replace_subtree(target: Types.Expr, replacement: Types.Expr, path: U32) -> Types.Expr:
  match path:
    case 0u: replacement
    case +p:
      match target:
        case Types.Expr/Val: replacement
        case Types.Expr/Var: replacement
        case Types.Expr/Add:
          match (p % 2u == 0u):
            case True: Types.Expr/Add { left: replace_subtree(target.left, replacement, p / 2u), right: target.right }
            case False: Types.Expr/Add { left: target.left, right: replace_subtree(target.right, replacement, p / 2u) }
        case Types.Expr/Mul:
          match (p % 2u == 0u):
            case True: Types.Expr/Mul { left: replace_subtree(target.left, replacement, p / 2u), right: target.right }
            case False: Types.Expr/Mul { left: target.left, right: replace_subtree(target.right, replacement, p / 2u) }
        case Types.Expr/Div:
          match (p % 2u == 0u):
            case True: Types.Expr/Div { num: replace_subtree(target.num, replacement, p / 2u), den: target.den }
            case False: Types.Expr/Div { num: target.num, den: replace_subtree(target.den, replacement, p / 2u) }
        case Types.Expr/Sin: Types.Expr/Sin { arg: replace_subtree(target.arg, replacement, p / 2u) }
        case Types.Expr/Cos: Types.Expr/Cos { arg: replace_subtree(target.arg, replacement, p / 2u) }
        case Types.Expr/Exp: Types.Expr/Exp { arg: replace_subtree(target.arg, replacement, p / 2u) }

# Operador de cruzamento de subárvores
def crossover(p1: Types.Expr, p2: Types.Expr, path1: U32, path2: U32) -> Types.Expr:
  donor = get_subtree(p2, path2)
  replace_subtree(p1, donor, path1)
