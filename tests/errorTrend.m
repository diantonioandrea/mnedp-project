% Andrea Di Antonio, 858798.
function errorTrend
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Tests.
	steps = 10;
	sizes = zeros(2, steps);
	errors = zeros(2, steps);

	%% Alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf('Errors evaluation, alpha = 5/3.\nSimple.\n')

	j = 1;
	[uh, ~, ~] = solver(uMesh, f);

	errors(1, j) = errorEstimate(uMesh, up, uh);
	sizes(1, j) = max(meshSizes); % length(uMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(uMesh.elements), errors(1, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);

		errors(1, j) = errorEstimate(uMesh, up, uh);
		sizes(1, j) = max(meshSizes); % length(uMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(uMesh.elements), errors(1, j));
	end

	%% Alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 2.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf('\n\nErrors evaluation, alpha = 10.\nSimple.\n')
	
	j = 1;
	[uh, ~, ~] = solver(uMesh, f);
	
	errors(2, j) = errorEstimate(uMesh, up, uh);
	sizes(2, j) = max(meshSizes); % length(uMesh.elements);

	fprintf('\nElements: %d\tError: %e.', ...
			length(uMesh.elements), errors(2, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);
		
		errors(2, j) = errorEstimate(uMesh, up, uh);
		sizes(2, j) = max(meshSizes); % length(uMesh.elements);
		
		fprintf('\nElements: %d\tError: %e.', ...
			length(uMesh.elements), errors(2, j));
	end

	%% Graphics.
	
	green = [33, 153, 0] / 255;
	red = [220, 50, 47] / 255;

	loglog(sizes(1, :), errors(1, :), ...
		DisplayName='alpha = 5/3', LineWidth=2, ...
		Color=red);

	hold on;

	loglog(sizes(2, :), errors(2, :), ...
		DisplayName='alpha = 10', LineWidth=2, ...
		Color=green);
	
	xlabel("Mesh Size (h)");
	ylabel("Error")

	hold off;
	legend;

	saveas(gcf, "../gallery/errorTrend", "jpeg")

	%% Interpolation

	coeffs = zeros(2, 2);
	coeffs(1, :) = polyfit(log(sizes(1, :)), ...
		log(errors(1, :)), 1);
	coeffs(2, :) = polyfit(log(sizes(2, :)), ...
		log(errors(2, :)), 1);
	
	% Prints coefficients.
	fprintf("\n\nInterpolation coefficients.")
	fprintf("\n\nalpha = 5/3, y = %fx + (%f)", ...
		coeffs(1, 1), coeffs(1, 2));
	fprintf("\nalpha = 10, y = %fx + (%f)\n", ...
		coeffs(2, 1), coeffs(2, 2));
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