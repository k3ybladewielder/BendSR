import Base
import ./Types.bend as Types
import ./Eval.bend as Eval
import ./LAWS.bend as LAWS

# Prova formal para a lei 'safe_tree_evaluation'
def LAWS.safe_tree_evaluation(expr, vars):
  # {==} e o construtor de prova por reflexividade (A == A)
  {==}
