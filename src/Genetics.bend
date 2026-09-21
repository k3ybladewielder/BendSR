import Base
import ./Types.bend as Types

def choose_expr(is_even: Bool, e1: Types.Expr, e2: Types.Expr) -> Types.Expr:
  match is_even:
    case True{}: e1
    case False{}: e2

def replace_branch_add(is_even: Bool, left: Types.Expr, right: Types.Expr, +new_child: Types.Expr) -> Types.Expr:
  match is_even:
    case True{}: Types.Add{new_child, right}
    case False{}: Types.Add{left, new_child}

def replace_branch_mul(is_even: Bool, left: Types.Expr, right: Types.Expr, +new_child: Types.Expr) -> Types.Expr:
  match is_even:
    case True{}: Types.Mul{new_child, right}
    case False{}: Types.Mul{left, new_child}

def replace_branch_div(is_even: Bool, num: Types.Expr, den: Types.Expr, +new_child: Types.Expr) -> Types.Expr:
  match is_even:
    case True{}: Types.Div{new_child, den}
    case False{}: Types.Div{num, new_child}

def mutate_var_help(is_even: Bool, +rng: U32) -> Types.Expr:
  match is_even:
    case True{}: Types.Val{U32.to_f32(U32.mod(rng, 10))}
    case False{}: Types.Var{}

# Mutação de nós da árvore
def mutate(expr: Types.Expr, +rng: U32) -> Types.Expr:
  match expr:
    case Types.Val{val}:
      +delta = F32.div(F32.sub(U32.to_f32(U32.mod(rng, 21)), 10.0), 10.0)
      Types.Val{F32.add(val, delta)}
    case Types.Var{}:
      mutate_var_help(U32.is_eq(U32.mod(rng, 2), 0), rng)
    case Types.Add{left, right}:
      Types.Add{mutate(left, U32.div(rng, 3)), right}
    case Types.Mul{left, right}:
      Types.Mul{mutate(left, U32.div(rng, 3)), right}
    case Types.Div{num, den}:
      Types.Div{mutate(num, U32.div(rng, 2)), den}
    case Types.Sin{arg}:
      Types.Sin{mutate(arg, U32.div(rng, 2))}
    case Types.Cos{arg}:
      Types.Cos{mutate(arg, U32.div(rng, 2))}
    case Types.Exp{arg}:
      Types.Exp{mutate(arg, U32.div(rng, 2))}

@unsafe
def get_subtree_step(+path: U32, is_zero: Bool, expr: Types.Expr) -> Types.Expr:
  match is_zero:
    case True{}: expr
    case False{}:
      match expr:
        case Types.Val{val}: Types.Val{val}
        case Types.Var{}: Types.Var{}
        case Types.Add{left, right}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), left, right)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case Types.Mul{left, right}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), left, right)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case Types.Div{num, den}:
          child = choose_expr(U32.is_eq(U32.mod(path, 2), 0), num, den)
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), child)
        case Types.Sin{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)
        case Types.Cos{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)
        case Types.Exp{arg}:
          +next_p = U32.div(path, 2)
          get_subtree_step(next_p, U32.is_eq(next_p, 0), arg)

# Extração de subárvore navegando por um caminho de bits
def get_subtree(expr: Types.Expr, +path: U32) -> Types.Expr:
  get_subtree_step(path, U32.is_eq(path, 0), expr)

@unsafe
def replace_subtree_step(+path: U32, is_zero: Bool, target: Types.Expr, +replacement: Types.Expr) -> Types.Expr:
  match is_zero:
    case True{}: replacement
    case False{}:
      match target:
        case Types.Val{val}: replacement
        case Types.Var{}: replacement
        case Types.Add{+left, +right}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, left, right)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_add(is_even, left, right, new_child)
        case Types.Mul{+left, +right}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, left, right)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_mul(is_even, left, right, new_child)
        case Types.Div{+num, +den}:
          +is_even = U32.is_eq(U32.mod(path, 2), 0)
          child = choose_expr(is_even, num, den)
          +next_p = U32.div(path, 2)
          new_child = replace_subtree_step(next_p, U32.is_eq(next_p, 0), child, replacement)
          replace_branch_div(is_even, num, den, new_child)
        case Types.Sin{arg}:
          +next_p = U32.div(path, 2)
          Types.Sin{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}
        case Types.Cos{arg}:
          +next_p = U32.div(path, 2)
          Types.Cos{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}
        case Types.Exp{arg}:
          +next_p = U32.div(path, 2)
          Types.Exp{replace_subtree_step(next_p, U32.is_eq(next_p, 0), arg, replacement)}

# Substituição de subárvore
def replace_subtree(target: Types.Expr, +replacement: Types.Expr, +path: U32) -> Types.Expr:
  replace_subtree_step(path, U32.is_eq(path, 0), target, replacement)

# Operador de cruzamento de subárvores
def crossover(p1: Types.Expr, p2: Types.Expr, path1: U32, path2: U32) -> Types.Expr:
  donor = get_subtree(p2, path2)
  replace_subtree(p1, donor, path1)
