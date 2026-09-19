import Base
import Types
import Eval
import LAWS

# Prova formal para a lei 'safe_tree_evaluation'
def Laws.safe_tree_evaluation(expr: Types.Expr, x: F32):
  # {==} e o construtor de prova por reflexividade (A == A)
  {==}
