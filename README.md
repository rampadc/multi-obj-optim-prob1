# Multi-objective Optimisation with IBM ILOG CPLEX - Problem 1

This repository include accompanying code samples to the blog post [Multi-objective Optimisation with IBM ILOG CPLEX - Part 1](https://congx.dev/posts/multiobjective-optimisation-with-ibm-ilog-cplex-1/).

## Getting Started

1. Install the community desktop version for IBM ILOG CPLEX Optimization Studio from [IBM ILOG CPLEX website](https://www.ibm.com/au-en/products/ilog-cplex-optimization-studio).
2. Clone the repository into a folder. 
3. Once the IDE is installed, navigate to `File > Import > Existing OPL projects`.
4. Choose the cloned folder as the root directory. Select the project and click `Finish`.

There are three Run Configurations provided:

- `cp`: uses the `staticLex` method with CP Optimizer
- `cplex`: uses the `staticLexFull` method with CPLEX Optimizer
- `cplex-external-main`: uses the `staticLexFull` method with CPLEX Optimizer. This additionally use an external data file to dynamically change the weighting of the optimisation.

Right-click on any of these Run Configurations, and click on `Run this`.

Open the `Scripting log` panel at the bottom of the perspective to view the results as the optimisation is performed.