% Andrea Di Antonio, 858798.
function errorTrend(~)
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/errorTrend.txt','w');

	% Tests.
	steps = 10;
	sizes = zeros(2, steps);
	errors = zeros(2, steps);

	%% alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf(fileID, 'Errors evaluation, alpha = 5/3\n');

	j = 1;
	[uh, ~, ~] = solver(uMesh, f);

	errors(1, j) = errorEstimate(uMesh, up, uh);
	sizes(1, j) = max(meshSizes);

	fprintf(fileID, '\nSize: %d\tError: %.2e', ...
			sizes(1, j), errors(1, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);

		errors(1, j) = errorEstimate(uMesh, up, uh);
		sizes(1, j) = max(meshSizes);
		
		fprintf(fileID, '\nSize: %d\tError: %.2e', ...
			sizes(1, j), errors(1, j));
	end

	%% alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 2.
	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf(fileID, '\n\nErrors evaluation, alpha = 10\n');
	
	j = 1;
	[uh, ~, ~] = solver(uMesh, f);
	
	errors(2, j) = errorEstimate(uMesh, up, uh);
	sizes(2, j) = max(meshSizes);

	fprintf(fileID, '\nSize: %d\tError: %.2e', ...
			sizes(2, j), errors(2, j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[uh, ~, ~] = solver(uMesh, f);
		
		errors(2, j) = errorEstimate(uMesh, up, uh);
		sizes(2, j) = max(meshSizes);
		
		fprintf(fileID, '\nSize: %d\tError: %.2e', ...
			sizes(2, j), errors(2, j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	orange = [203, 75, 22] / 255;
	blue = [38	139	210] / 255;

	loglog(sizes(1, :), errors(1, :), ...
		DisplayName='\alpha = 5/3', LineWidth=2, ...
		Color=orange);

	hold on;

	loglog(sizes(2, :), errors(2, :), ...
		DisplayName='\alpha = 10', LineWidth=2, ...
		Color=green);
	
	xlabel('Mesh Size (h)');
	ylabel('|u - u_h|_{1, \Omega}');

	% Interpolation

	coeffs = zeros(2, 2);
	coeffs(1, :) = polyfit(log(sizes(1, :)), ...
		log(errors(1, :)), 1);
	coeffs(2, :) = polyfit(log(sizes(2, :)), ...
		log(errors(2, :)), 1);
	
	loglog(sizes(1, :), exp(coeffs(1, 2)) * (sizes(1, :) .^ ...
		coeffs(1, 1)), LineWidth=2, Color=blue, ...
		LineStyle='--', DisplayName='\alpha = 5/3 Interpolant');
	loglog(sizes(2, :), exp(coeffs(2, 2)) * (sizes(2, :) .^ ...
		coeffs(2, 1)), LineWidth=2, Color=blue, ...
		LineStyle='--', DisplayName='\alpha = 10 Interpolant');
	
	% Prints coefficients.
	fprintf(fileID, '\n\nLoglog interpolation');
	fprintf(fileID, '\n\nalpha = 5/3 Interpolant: y = %fx + (%f)', ...
		coeffs(1, 1), coeffs(1, 2));
	fprintf(fileID, '\nalpha = 10 Interpolant: y = %fx + (%f)\n', ...
		coeffs(2, 1), coeffs(2, 2));

	hold off;
	legend(location='northwest');

	if nargin > 0
		bck = [253	246	227] / 255;
	
		set(gca,'color', bck)
		set(legend, 'color', bck)
		
		exportgraphics(gcf, '../gallery/errorTrend.pdf', ...
			'ContentType', 'vector', 'BackgroundColor', bck)

	else
		exportgraphics(gcf, '../gallery/errorTrend.pdf', ...
			'ContentType', 'vector')
	end
end