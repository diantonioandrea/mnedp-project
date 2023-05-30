# Metodi Numerici per Equazioni alle Derivate Parziali

Codice per l'esame consegne del corso Metodi Numerici per Equazioni alle Derivate Parziali.

## Codice

Implementazione di un metodo "Adaptive 1D 1st-order Lagrange FEM" per la soluzione del problema di Poisson con dati al bordo di Dirichlet.

## Contenuti

- `/src/*` Codice sorgente per il FEM.
	- `/src/builder.m` Costruttore della mesh.
	- `/src/marker.m` Marcatore della mesh.
	- `/src/refiner.m` Raffinatore della mesh.
	- `/src/solver.m` Risolutore del prolema di Poisson sulla mesh.
- `/main/main.m` Codice sorgente di test per la relazione.
