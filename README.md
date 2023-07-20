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
- `report/report.tex` Relazione in *LaTeX*.
- `/tests/*` Codici sorgente di test per la relazione.
	- `/tests/comparison.m` Confronto dell'errore tra il metodo adattivo e il metodo di raffinamento classico.
	- `/tests/comparisonCond.m` Confronto del numero di condizionamento della matrice di stiffness tra il metodo adattivo e il metodo di raffinamento classico.
	- `/tests/condition.m` Studio dell'andamento del numero di condizionamento della matrice A.
	- `/tests/errorTrend.m` Studio della convergenza del metodo su mesh uniformi.
	- `/tests/graphical.m` Confronto qualitativo tra la soluzione analitica e numerica.
	- `/tests/reliability.m` Affidabilità dello stimatore dell'errore del metodo adattivo.
	- `/tests/private/errorEstimate.m` Stima dell'errore in seminorma H<sub>1</sub>.

## Indice dei test

Test usati nel corso della relazione.

- 3: **Tests on Uniformly Refined Meshes**
	- 3.1: `/tests/graphical.m`
	- 3.2: `/tests/errorTrend.m`
	- 3.3: `/tests/condition.m`
- 4: **Adaptive Refinement Method**
	- 4.2: `/tests/reliability.m`
- 5: **Comparisons Between the two Approaches**
	- 5.1: `/tests/comparison.m`
	- 5.2: `/tests/comparisonCond.m`

## Note aggiuntive

I codici di test producono file di testo di risultato e immagini rispettivamente in `../results/` e `../gallery/` rispetto alla cartella di esecuzione.