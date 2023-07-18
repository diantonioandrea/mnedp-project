% Andrea Di Antonio, 858798
function reliability
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/reliability.txt','w');

	% Tests.
	steps = 10;
	sizes = zeros(2, steps);
	errors = zeros(2, steps);
	estimates = zeros(2, steps);

	%% alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf(fileID, ['Errors and estimator ' ...
		'evaluation, alpha = 5/3.\n']);

	j = 1;
	[uh, ~, ~] = solver(uMesh, f);
	
	[~, estimates(1, j)] = estimate(uMesh, f);
	errors(1, j) = errorEstimate(uMesh, up, uh);
	sizes(1, j) = max(meshSizes);

	fprintf(fileID, '\nSize: %d\tError: %.2e\tEstimator: %.2e.', ...
			sizes(1, j), errors(1, j), estimates(1, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);
		
		[~, estimates(1, j)] = estimate(uMesh, f);
		errors(1, j) = errorEstimate(uMesh, up, uh);
		sizes(1, j) = max(meshSizes);
		
		fprintf(fileID, '\nSize: %d\tError: %.2e\tEstimator: %.2e.', ...
			sizes(1, j), errors(1, j), estimates(1, j));
	end

	%% alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 2.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf(fileID, ['\n\nErrors and estimator ' ...
		'evaluation, alpha = 5/3.\n']);

	j = 1;
	[uh, ~, ~] = solver(uMesh, f);
	
	[~, estimates(2, j)] = estimate(uMesh, f);
	errors(2, j) = errorEstimate(uMesh, up, uh);
	sizes(2, j) = max(meshSizes);

	fprintf(fileID, '\nSize: %d\tError: %.2e\tEstimator: %.2e.', ...
			sizes(2, j), errors(2, j), estimates(2, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);
		
		[~, estimates(2, j)] = estimate(uMesh, f);
		errors(2, j) = errorEstimate(uMesh, up, uh);
		sizes(2, j) = max(meshSizes);
		
		fprintf(fileID, '\nSize: %d\tError: %.2e\tEstimator: %.2e.', ...
			sizes(2, j), errors(2, j), estimates(2, j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	red = [220, 50, 47] / 255;

	tiledlayout(2, 1);

	nexttile;
	loglog(sizes(1, :), errors(1, :), ...
		DisplayName='\alpha = 5/3 errors', LineWidth=2, ...
		Color=green);

	hold on;

	loglog(sizes(1, :), estimates(1, :), ...
		DisplayName='\alpha = 5/3 \eta', LineWidth=2, ...
		Color=red);

	xlabel("Mesh Size (h)");
	ylabel("|u - u_h|_{1, \Omega}, \eta");

	hold off;
	legend(Location='southeast');

	nexttile;
	loglog(sizes(2, :), errors(2, :), ...
		DisplayName='\alpha = 10 errors', LineWidth=2, ...
		Color=green);

	hold on;

	loglog(sizes(2, :), estimates(2, :), ...
		DisplayName='\alpha = 10 \eta', LineWidth=2, ...
		Color=red);

	xlabel("Mesh Size (h)");
	ylabel("|u - u_h|_{1, \Omega}, \eta");

	hold off;
	legend(Location='southeast');

	saveas(gcf, "../gallery/reliability", "jpeg")
end