# Metodi Numerici per Equazioni alle Derivate Parziali

Codes and report for the exam of the **Metodi Numerici per Equazioni alle Derivate Parziali**[^1] course at **UniMiB**.

[^1]: Numerical Methods for Partial Differential Equations.

## Code

Implementation of an "Adaptive 1D 1st-order Lagrange FEM" method for solving the Poisson problem with Dirichlet boundary data.

## Contents

- `/src/*` Source code for FEM.
	- `/src/builder.m` Mesh builder.
	- `/src/estimate.m` Error estimator.
	- `/src/marker.m` Mesh marker.
	- `/src/refiner.m` Mesh refiner.
	- `/src/solver.m` Poisson problem solver on the mesh.
- `report/report.tex` Report in *LaTeX*.
- `/tests/*` Test source codes for the report.
	- `/tests/comparison.m` Error comparison between adaptive method and classical refinement method.
	- `/tests/comparisonCond.m` Comparison of the conditioning number of the stiffness matrix between the adaptive method and the classical refinement method.
	- `/tests/condition.m` Study of the trend of the conditioning number of matrix A.
	- `/tests/errorTrend.m` Convergence study of the method on uniform meshes.
	- `/tests/graphical.m` Qualitative comparison between analytical and numerical solutions.
	- `/tests/reliability.m` Reliability of the error estimator of the adaptive method.
	- `/tests/private/errorEstimate.m` Error estimation in H<sub>1</sub> seminorm.

## Test Index

Tests used in the course of the report.

- 3: **Tests on Uniformly Refined Meshes**
	- 3.1: `/tests/graphical.m`
	- 3.2: `/tests/errorTrend.m`
	- 3.3: `/tests/condition.m`
- 4: **Adaptive Refinement Method**
	- 4.2: `/tests/reliability.m`
- 5: **Comparisons Between the two Approaches**
	- 5.1: `/tests/comparison.m`
	- 5.2: `/tests/comparisonCond.m`

## Additional Notes

The test codes produce result text files and images respectively in `../results/` and `../gallery/` relative to the execution folder.