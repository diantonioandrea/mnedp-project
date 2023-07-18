% Andrea Di Antonio, 858798.
function comparison
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/comparison.txt','w');

	% Tests.
	steps = 10;
	sizes = zeros(4, steps);
	errors = zeros(4, steps);

	%% Alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	firstMesh = builder(5);

	fprintf(fileID, 'Errors evaluation, alpha = 5/3.\nSimple.\n');
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);

	errors(1, j) = errorEstimate(firstMesh, up, uh);
	sizes(1, j) = length(firstMesh.elements);

	fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(firstMesh.elements), errors(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);

		errors(1, j) = errorEstimate(firstMesh, up, uh);
		sizes(1, j) = length(firstMesh.elements);
		
		fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(firstMesh.elements), errors(1, j));
	end
	
	% Test 2.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);

	errors(2, j) = errorEstimate(secondMesh, up, uh);
	sizes(2, j) = length(secondMesh.elements);

	fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(secondMesh.elements), errors(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);

		errors(2, j) = errorEstimate(secondMesh, up, uh);
		sizes(2, j) = length(secondMesh.elements);
		
		fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(secondMesh.elements), errors(2, j));
	end
	%% Alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 3.
	firstMesh = builder(5);

	fprintf(fileID, '\n\nErrors evaluation, alpha = 10.\nSimple.\n');
	
	j = 1;
	[uh, ~, ~] = solver(firstMesh, f);
	
	errors(3, j) = errorEstimate(firstMesh, up, uh);
	sizes(3, j) = length(firstMesh.elements);

	fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(firstMesh.elements), errors(3, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, ~, ~] = solver(firstMesh, f);
		
		errors(3, j) = errorEstimate(firstMesh, up, uh);
		sizes(3, j) = length(firstMesh.elements);
		
		fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(firstMesh.elements), errors(3, j));
	end

	% Test 4.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[uh, ~, ~] = solver(secondMesh, f);
	
	errors(4, j) = errorEstimate(secondMesh, up, uh);
	sizes(4, j) = length(secondMesh.elements);

	fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(secondMesh.elements), errors(4, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, ~, ~] = solver(secondMesh, f);
		
		errors(4, j) = errorEstimate(secondMesh, up, uh);
		sizes(4, j) = length(secondMesh.elements);
		
		fprintf(fileID, '\nElements: %d\tError: %.2e.', ...
			length(secondMesh.elements), errors(4, j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	red = [220, 50, 47] / 255;
	
	tiledlayout(2, 1);

	% Alpha = 5/3.
	nexttile;
	loglog(sizes(1, :), errors(1, :), ...
		DisplayName='Simple, \alpha = 5/3.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(sizes(2, :), errors(2, :), ...
		DisplayName='Adaptive, \alpha = 5/3.', LineWidth=2, ...
		Color=green);

	xlabel("Number of elements");
	ylabel("|u - u_h|_{1, \Omega}");

	hold off;
	legend;
	
	% Alpha = 10.
	nexttile;
	loglog(sizes(3, :), errors(3, :), ...
		DisplayName='Simple, \alpha = 10.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(sizes(4, :), errors(4, :), ...
		DisplayName='Adaptive, \alpha = 10.', LineWidth=2, ...
		Color=green);

	xlabel("Number of elements");
	ylabel("|u - u_h|_{1, \Omega}");

	hold off;
	legend;
	
	exportgraphics(gcf, "../gallery/comparison.pdf", ...
		'ContentType', 'vector')
end