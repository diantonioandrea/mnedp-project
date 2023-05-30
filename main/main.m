% I prefere using a function not to have variables in the
% workspace.
function main
	addpath("../src")
	
	%% Initialization
	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Starting mesh.
	sMesh = builder(5); % Built with 4 starting elements.

	% Tests.
	steps = 10;
	errors = zeros(2, steps);

	%% Alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);

	firstMesh = sMesh;

	fprintf("1. Valutazione degli errori con alpha = 5/3.\nMetodo semplice.\n")
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);
	errors(1, j) = errorEstimate(firstMesh, up, uh);

	fprintf("\nElements: %d\tError: %e.", ...
			length(firstMesh.elements), errors(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);
		errors(1, j) = errorEstimate(firstMesh, up, uh);
		
		fprintf("\nElements: %d\tError: %e.", ...
			length(firstMesh.elements), errors(1, j));
	end
	
	secondMesh = sMesh;

	fprintf("\n\nMetodo adattivo.\n")

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);
	errors(2, j) = errorEstimate(secondMesh, up, uh);

	fprintf("\nElements: %d\tError: %e.", ...
			length(secondMesh.elements), errors(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);
		errors(2, j) = errorEstimate(secondMesh, up, uh);
		
		fprintf("\nElements: %d\tError: %e.", ...
			length(secondMesh.elements), errors(2, j));
	end
	%% Alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);

	firstMesh = sMesh;

	fprintf("\n\n2.Valutazione degli errori con alpha = 10.\nMetodo semplice.\n")
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);
	errors(1, j) = errorEstimate(firstMesh, up, uh);

	fprintf("\nElements: %d\tError: %e.", ...
			length(firstMesh.elements), errors(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);
		errors(1, j) = errorEstimate(firstMesh, up, uh);
		
		fprintf("\nElements: %d\tError: %e.", ...
			length(firstMesh.elements), errors(1, j));
	end

	secondMesh = sMesh;

	fprintf("\n\nMetodo adattivo.\n")

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);
	errors(2, j) = errorEstimate(secondMesh, up, uh);

	fprintf("\nElements: %d\tError: %e.", ...
			length(secondMesh.elements), errors(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);
		errors(2, j) = errorEstimate(secondMesh, up, uh);
		
		fprintf("\nElements: %d\tError: %e.", ...
			length(secondMesh.elements), errors(2, j));
	end
end

function err = errorEstimate(mesh, up, uh)
	err = 0;

	for j = 1:length(mesh.nodes) - 1
		h = mesh.elements(j, 3);
		xs = mesh.nodes(j);
		xd = mesh.nodes(j + 1);

		err = err + .5 * h * sqrt((up(xs) - uh(j))^2 + ...
			(up(xd) - uh(j + 1))^2);
	end
end