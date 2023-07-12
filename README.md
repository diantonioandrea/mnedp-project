# Metodi Numerici per Equazioni alle Derivate Parziali

Codici e relazione per l'esame del corso **Metodi Numerici per Equazioni alle Derivate Parziali**.

## Codice

Implementazione di un metodo "Adaptive 1D 1st-order Lagrange FEM" per la soluzione del problema di Poisson con dati al bordo di Dirichlet.

## Contenuto

- `/src/*` Codice sorgente per il FEM.
	- `/src/builder.m` Costruttore della mesh.
	- `/src/marker.m` Marcatore della mesh.
	- `/src/refiner.m` Raffinatore della mesh.
	- `/src/solver.m` Risolutore del prolema di Poisson sulla mesh.
- `/tests/*` Codici sorgente di test per la relazione.
	- `/tests/graphical.m` Confronto qualitativo tra la soluzione analitica e numerica.
	- `/tests/errorTrend.m` Studio della convergenza del metodo su mesh uniformi.
	- `/tests/condition.m` Studio dell'andamento del numero di condizionamento della matrice A.
	- `/tests/comparison.m` Confronto tra il metodo adattivo e il metodo di raffinamento classico.
- `report/report.tex` Relazione.
