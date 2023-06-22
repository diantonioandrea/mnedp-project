% Andrea Di Antonio, 858798.
function comparison
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Tests.
	steps = 10;
	sizes = zeros(4, steps);
	errors = zeros(4, steps);

	%% Alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	firstMesh = builder(5);

	fprintf('Errors evaluation, alpha = 5/3.\nSimple.\n')
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);

	errors(1, j) = errorEstimate(firstMesh, up, uh);
	sizes(1, j) = length(firstMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(firstMesh.elements), errors(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);

		errors(1, j) = errorEstimate(firstMesh, up, uh);
		sizes(1, j) = length(firstMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(firstMesh.elements), errors(1, j));
	end
	
	% Test 2.
	secondMesh = builder(5);

	fprintf('\n\nAdaptive.\n')

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);

	errors(2, j) = errorEstimate(secondMesh, up, uh);
	sizes(2, j) = length(secondMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(secondMesh.elements), errors(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);

		errors(2, j) = errorEstimate(secondMesh, up, uh);
		sizes(2, j) = length(secondMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(secondMesh.elements), errors(2, j));
	end
	%% Alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 3.
	firstMesh = builder(5);

	fprintf('\n\nErrors evaluation, alpha = 10.\nSimple.\n')
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);
	
	errors(3, j) = errorEstimate(firstMesh, up, uh);
	sizes(3, j) = length(firstMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(firstMesh.elements), errors(3, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);
		
		errors(3, j) = errorEstimate(firstMesh, up, uh);
		sizes(3, j) = length(firstMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(firstMesh.elements), errors(3, j));
	end

	% Test 4.
	secondMesh = builder(5);

	fprintf('\n\nAdaptive.\n')

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);
	
	errors(4, j) = errorEstimate(secondMesh, up, uh);
	sizes(4, j) = length(secondMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(secondMesh.elements), errors(4, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);
		
		errors(4, j) = errorEstimate(secondMesh, up, uh);
		sizes(4, j) = length(secondMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(secondMesh.elements), errors(4, j));
	end

	%% Graphics.
	
	green = [33, 153, 0] / 255;
	red = [220, 50, 47] / 255;

	tiledlayout(2, 1);
	for j = 1:2:4
		nexttile;
		loglog(sizes(j, :), errors(j, :), ...
			DisplayName='Simple', LineWidth=2, ...
			Color=red);
		hold on;

		loglog(sizes(j + 1, :), errors(j + 1, :), ...
			DisplayName='Adaptive.', LineWidth=2, ...
			Color=green);

		hold off;
		legend;
	end
end

function err = errorEstimate(mesh, up, uh)
	err = 0;

	for j = 1:length(mesh.nodes) - 1
		h = mesh.elements(j, 3);
		xs = mesh.nodes(j);
		xd = mesh.nodes(j + 1);

		gh = (uh(j + 1) - uh(j)) / h;

		err = err + .5 * h * sqrt((up(xs) - gh)^2 + ...
			(up(xd) - gh)^2);
	end
end