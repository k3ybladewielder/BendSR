import Base
import ./Types.bend as Types
import ./Eval.bend as Eval
import ./Genetics.bend as Genetics

# Avalia um único indivíduo
def eval_individual(+tree: Types.Expr, +points: +List<Types.Point>) -> Types.Individual:
  mae = Eval.compute_mae!(tree, points)
  Types.Ind{tree, mae}

# Avalia toda a população em paralelo
def evaluate_population(pop: +List<Types.Expr>, +points: +List<Types.Point>) -> +List<Types.Individual>:
  match pop:
    case Nil{}: Nil{}
    case Con{+head, tail}:
      ind = eval_individual!(head, points)
      tail_eval = evaluate_population!(tail, points)
      Con{ind, tail_eval}

# Busca um elemento na lista pelo índice
def get_at(+idx: U32, pop: +List<Types.Individual>) -> Types.Individual:
  match idx:
    case 0:
      match pop:
        case Nil{}: Types.Ind{Types.Val{0.0}, 999999.0}
        case Con{head, tail}: head
    case +p:
      match pop:
        case Nil{}: Types.Ind{Types.Val{0.0}, 999999.0}
        case Con{head, tail}: get_at(p, tail)

def tournament_select(is_less: Bool, tree1: Types.Expr, tree2: Types.Expr) -> Types.Expr:
  match is_less:
    case True{}: tree1
    case False{}: tree2

def tournament_step2(ind2: Types.Individual, t1: Types.Expr, f1: F32) -> Types.Expr:
  match ind2:
    case Types.Ind{t2, f2}:
      tournament_select(F32.is_lt(f1, f2), t1, t2)

def tournament_step(ind1: Types.Individual, ind2: Types.Individual) -> Types.Expr:
  match ind1:
    case Types.Ind{t1, f1}:
      tournament_step2(ind2, t1, f1)

# Seleção por torneio entre 2 indivíduos aleatórios
def tournament(+pop: +List<Types.Individual>, +pop_len: U32, +rng: U32) -> Types.Expr:
  i1 = U32.mod(rng, pop_len)
  i2 = U32.mod(U32.div(rng, 7), pop_len)
  tournament_step(get_at(i1, pop), get_at(i2, pop))

# Gera um descendente combinando torneio, crossover e mutação
def breed_child(+pop: +List<Types.Individual>, +pop_len: U32, +rng: U32) -> Types.Expr:
  p1 = tournament(pop, pop_len, rng)
  p2 = tournament(pop, pop_len, U32.add(rng, 101))
  offspring = Genetics.crossover(p1, p2, U32.mod(rng, 16), U32.mod(U32.div(rng, 3), 16))
  Genetics.mutate(offspring, U32.add(rng, 999))

# Cria a nova geração em paralelo
@unsafe
def generate_next_pop(count: U32, +pop: +List<Types.Individual>, +pop_len: U32, +seed: U32) -> +List<Types.Expr>:
  match count:
    case 0: Nil{}
    case +c:
      child = breed_child!(pop, pop_len, U32.add(seed, U32.mul(count, 37)))
      rest = generate_next_pop!(c, pop, pop_len, seed)
      Con{child, rest}

# Loop recursivo de evolução
def evolve(gen: Nat, pop: +List<Types.Expr>, +points: +List<Types.Point>, +pop_len: U32, +seed: U32) -> +List<Types.Individual>:
  match gen:
    case 0n:
      evaluate_population!(pop, points)
    case 1n++g:
      evaluated = evaluate_population!(pop, points)
      next_pop = generate_next_pop!(pop_len, evaluated, pop_len, U32.add(seed, U32.mul(U32.from_nat(g), 1000)))
      evolve!(g, next_pop, points, pop_len, seed)
