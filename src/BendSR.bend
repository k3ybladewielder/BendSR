# BendSR: Massively Parallel Symbolic Regression Engine in Bend
#
# BendSR is a high-performance Symbolic Regression implementation built for the Bend 2 language.
# It leverages Interaction Nets to evaluate populations of expression trees in parallel across CPU and GPU hardware.
#
# Modules Exposed:
# - Types: Abstract Syntax Trees (Expr), Datasets, Points, and FList representation.
# - Eval: Parallel Mean Absolute Error (MAE) calculation engine over datasets.
# - Genetics: Subtree crossover, node mutation, and tree manipulation routines.
# - Engine: Tournament selection, generation breeding, and evolutionary search loop.

import Base
import ./Types.bend as T
import ./Eval.bend as E
import ./Genetics.bend as G
import ./Engine.bend as Eng
