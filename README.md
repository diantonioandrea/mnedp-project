# Metodi Numerici per Equazioni alle Derivate Parziali

Codici e relazione per l'esame del corso **Metodi Numerici per Equazioni alle Derivate Parziali**.

## Codice

Implementazione di un metodo "Adaptive 1D 1st-order Lagrange FEM" per la soluzione del problema di Poisson con dati al bordo di Dirichlet.

## Contenuto

- `/src/*` Codice sorgente per il FEM.
	- `/src/builder.m` Costruttore della mesh.
	- `/src/estimate.m` Stimatore dell'errore.
	- `/src/marker.m` Marcatore della mesh.
	- `/src/refiner.m` Raffinatore della mesh.
	- `/src/solver.m` Risolutore del prolema di Poisson sulla mesh.
- `/tests/*` Codici sorgente di test per la relazione.
	- `/tests/private/errorEstimate.m` Stima dell'errore in seminorma H<sub>1</sub>.
	- `/tests/graphical.m` Confronto qualitativo tra la soluzione analitica e numerica.
	- `/tests/errorTrend.m` Studio della convergenza del metodo su mesh uniformi.
	- `/tests/condition.m` Studio dell'andamento del numero di condizionamento della matrice A.
	- `/tests/comparison.m` Confronto dell'errore tra il metodo adattivo e il metodo di raffinamento classico.
	- `/tests/comparisonCond.m` Confronto del numero di condizionamento della matrice di stiffness tra il metodo adattivo e il metodo di raffinamento classico.
	- `/tests/reliability.m` Affidabilità dello stimatore dell'errore del metodo adattivo.
- `report/report.tex` Relazione in *LaTeX*.
