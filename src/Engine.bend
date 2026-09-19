import Base
import Types
import Eval
import Genetics

# Avalia um único indivíduo
def eval_individual(tree: Types.Expr, points: List<(F32, F32)>) -> Types.Individual:
  mae = Eval.compute_mae!(tree, points)
  Types.Individual/Ind { tree: tree, fitness: mae }

# Avalia toda a população em paralelo
def evaluate_population(pop: List<Types.Expr>, points: List<(F32, F32)>) -> List<Types.Individual>:
  match pop:
    case List/Nil: List/Nil
    case List/Cons:
      ind = eval_individual!(pop.head, points)
      tail_eval = evaluate_population!(pop.tail, points)
      List/Cons { head: ind, tail: tail_eval }

# Busca um elemento na lista pelo índice
def get_at(pop: List<Types.Individual>, idx: U32) -> Types.Individual:
  match pop:
    case List/Nil: Types.Individual/Ind { tree: Types.Expr/Val { val: 0.0 }, fitness: 999999.0 }
    case List/Cons:
      match idx:
        case 0u: pop.head
        case +p: get_at(pop.tail, p)

# Seleção por torneio entre 2 indivíduos aleatórios
def tournament(pop: List<Types.Individual>, pop_len: U32, rng: U32) -> Types.Expr:
  i1 = rng % pop_len
  i2 = (rng / 7u) % pop_len
  ind1 = get_at(pop, i1)
  ind2 = get_at(pop, i2)
  match ind1:
    case Types.Individual/Ind:
      match ind2:
        case Types.Individual/Ind:
          match (ind1.fitness < ind2.fitness):
            case True: ind1.tree
            case False: ind2.tree

# Gera um descendente combinando torneio, crossover e mutação
def breed_child(pop: List<Types.Individual>, pop_len: U32, rng: U32) -> Types.Expr:
  p1 = tournament(pop, pop_len, rng)
  p2 = tournament(pop, pop_len, rng + 101u)
  offspring = Genetics.crossover(p1, p2, rng % 16u, (rng / 3u) % 16u)
  Genetics.mutate(offspring, rng + 999u)

# Cria a nova geração em paralelo
def generate_next_pop(pop: List<Types.Individual>, pop_len: U32, count: U32, seed: U32) -> List<Types.Expr>:
  match count:
    case 0u: List/Nil
    case +c:
      child = breed_child!(pop, pop_len, seed + count * 37u)
      rest = generate_next_pop!(pop, pop_len, c, seed)
      List/Cons { head: child, tail: rest }

# Loop recursivo de evolução
def evolve(pop: List<Types.Expr>, points: List<(F32, F32)>, pop_len: U32, gen: Nat, seed: U32) -> List<Types.Individual>:
  evaluated = evaluate_population!(pop, points)
  match gen:
    case 0n: evaluated
    case 1n+g:
      next_pop = generate_next_pop!(evaluated, pop_len, pop_len, seed + U32.to_u32(g) * 1000u)
      evolve!(next_pop, points, pop_len, g, seed)
