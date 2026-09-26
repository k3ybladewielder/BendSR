import Base
import ./Types.bend as T
import ./Eval.bend as E
import ./LAWS.bend as L

# Prova formal para a lei 'safe_tree_evaluation'
def L.safe_tree_evaluation(expr, vars):
  # {==} e o construtor de prova por reflexividade (A == A)
  {==}
