% Andrea Di Antonio, 858798.
% Solves the 1D Poisson problem with Dirichlet boundary
% conditions on the specified mesh by first evaluating
% A and b and solving Auh = b for uh (uh = A\b).
% Also returns A and b.
function [uh, A, b] = solver(mesh, f)
	% Initialization.
	nds = mesh.nodes;
	szs = mesh.elements(:, 3); % Elements sizes.

	A = zeros(length(nds) - 2);
	b = zeros(length(nds) - 2, 1);

	% Build the matrix A and the vector b.
	% First row.
	j = 1;

	hs = szs(j);
	hd = szs(j + 1);

	xms = mesh.centres(j);
	xmd = mesh.centres(j + 1);

	A(j, j) = 1 / hs + 1 / hd;
	A(j, j + 1) = -1 / hd;

	b(j) = .5 * (hs * f(xms) + hd * f(xmd));

	% Internal part of A and b.
	for j = 2:length(nds) - 3
		hs = szs(j);
		hd = szs(j + 1);
	
		xms = mesh.centres(j);
		xmd = mesh.centres(j + 1);
		
		A(j, j - 1) = -1 / hs;
		A(j, j) = 1 / hs + 1 / hd;
		A(j, j + 1) = -1 / hd;
	
		b(j) = .5 * (hs * f(xms) + hd * f(xmd));
	end

	% Last row.
	j = length(nds) - 2;

	hs = szs(j);
	hd = szs(j + 1);

	xms = mesh.centres(j);
	xmd = mesh.centres(j + 1);
	
	A(j, j - 1) = -1 / hs;
	A(j, j) = 1 / hs + 1 / hd;

	b(j) = .5 * (hs * f(xms) + hd * f(xmd));

	% Solution.
	uh = A\b;
	uh = [0 uh' 0]; % Applies DBC.
end