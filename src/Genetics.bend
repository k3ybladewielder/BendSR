import Base
import ./Types.bend as T

def choose_expr(is_even: Bool, e1: T.Expr, e2: T.Expr) -> T.Expr:
  match is_even:
    case True{}: e1
    case False{}: e2

def replace_branch_add(is_even: Bool, left: T.Expr, right: T.Expr, +new_child: T.Expr) -> T.Expr:
  match is_even:
    case True{}: T.Add{new_child, right}
    case False{}: T.Add{left, new_child}

def replace_branch_mul(is_even: Bool, left: T.Expr, right: T.Expr, +new_child: T.Expr) -> T.Expr:
  match is_even:
    case True{}: T.Mul{new_child, right}
    case False{}: T.Mul{left, new_child}

def replace_branch_div(is_even: Bool, num: T.Expr, den: T.Expr, +new_child: T.Expr) -> T.Expr:
  match is_even:
    case True{}: T.Div{new_child, den}
    case False{}: T.Div{num, new_child}

def mutate_var_help(is_even: Bool, +rng: U32) -> T.Expr:
  match is_even:
    case True{}: T.Val{U32.to_f32(U32.mod(rng, 10))}
    case False{}: T.Var{U32.mod(rng, 3)}

# Mutação de nós da árvore
def mutate(expr: T.Expr, +rng: U32) -> T.Expr:
  match expr:
    case T.Val{val}:
      +delta = F32.div(F32.sub(U32.to_f32(U32.mod(rng, 21)), 10.0), 10.0)
      T.Val{F32.add(val, delta)}
    case T.Var{idx}:
      mutate_var_help(U32.is_eq(U32.mod(rng, 2), 0), rng)
    case T.Add{left, right}:
      T.Add{mutate(left, U32.div(rng, 3)), right}
    case T.Mul{left, right}:
      T.Mul{mutate(left, U32.div(rng, 3)), right}
    case T.Div{num, den}:
      T.Div{mutate(num, U32.div(rng, 2)), den}
    case T.Sin{arg}:
      T.Sin{mutate(arg, U32.div(rng, 2))}
    case T.Cos{arg}:
      T.Cos{mutate(arg, U32.div(rng, 2))}
    case T.Exp{arg}:
      T.Exp{mutate(arg, U32.div(rng, 2))}

@unsafe
def get_subtree_step(+path: U32, is_zero: Bool, expr: T.Expr) -> T.Expr:
  match is_zero:
    case True{}: expr
    case False{}:
      match expr:
        case T.Val{val}: T.Val{val}
        case T.Var{idx}: T.Var{idx}
        case T.Add{left, right}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), left, right)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case T.Mul{left, right}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), left, right)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case T.Div{num, den}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), num, den)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case T.Sin{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)
        case T.Cos{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)
        case T.Exp{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)

# Extração de subárvore navegando por um caminho de bits
def get_subtree(expr: T.Expr, +path: U32) -> T.Expr:
  get_subtree_step(path, U32.is_eq(path, 0), expr)

@unsafe
def replace_subtree_step(+path: U32, is_zero: Bool, target: T.Expr, +replacement: T.Expr) -> T.Expr:
  match is_zero:
    case True{}: replacement
    case False{}:
      match target:
        case T.Val{val}: replacement
        case T.Var{idx}: replacement
        case T.Add{+left, +right}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, left, right)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_add(is_even, left, right, new_child)
        case T.Mul{+left, +right}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, left, right)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_mul(is_even, left, right, new_child)
        case T.Div{+num, +den}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, num, den)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_div(is_even, num, den, new_child)
        case T.Sin{arg}:
          +next_p = U32.div(path, 2)
          T.Sin{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}
        case T.Cos{arg}:
          +next_p = U32.div(path, 2)
          T.Cos{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}
        case T.Exp{arg}:
          +next_p = U32.div(path, 2)
          T.Exp{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}

# Substituição de subárvore
def replace_subtree(target: T.Expr, +replacement: T.Expr, +path: U32) -> T.Expr:
  replace_subtree_step(path, U32.is_eq(path, 0), target, replacement)

# Operador de cruzamento de subárvores
def crossover(p1: T.Expr, p2: T.Expr, path1: U32, path2: U32) -> T.Expr:
  donor = get_subtree(p2, path2)
  replace_subtree(p1, donor, path1)
