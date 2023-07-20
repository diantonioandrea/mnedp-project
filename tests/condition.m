% Andrea Di Antonio, 858798.
function condition(~)
	% FEM.
	addpath('../src')

	% Functions.
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/condition.txt','w');

	% Tests.
	steps = 10;
	sizes = zeros(1, steps);
	conds = zeros(1, steps);

	%% Test.
	% This test does not depend on the value of alpha.
	f = @(x) f_a(5/3, x);

	uMesh = builder(5);
	meshSizes = diff(uMesh.nodes);

	fprintf(fileID, 'Condition number evaluation');

	j = 1;
	[~, A, ~] = solver(uMesh, f);

	conds(j) = cond(A);
	sizes(j) = max(meshSizes);

	fprintf(fileID, '\nSize: %d\tCondition number: %.2e', ...
			sizes(j), conds(j));

	for j = 2:steps
		uMesh = refiner(uMesh, []);
		meshSizes = diff(uMesh.nodes);
		[~, A, ~] = solver(uMesh, f);

		conds(j) = cond(A);
		sizes(j) = max(meshSizes);
		
		fprintf(fileID, '\nSize: %d\tCondition number: %.2e', ...
			sizes(j), conds(j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	orange = [203, 75, 22] / 255;

	loglog(sizes(:), conds(:), ...
		DisplayName='Condition number', LineWidth=2, ...
		Color=green);

	hold on;
	
	xlabel('Mesh Size (h)');
	ylabel('\chi(A)');

	% Interpolation

	coeffs = zeros(1, 2);
	coeffs(:) = polyfit(log(sizes(:)), ...
		log(conds(:)), 1);
	
	loglog(sizes(:), exp(coeffs(2)) * (sizes(:) .^ ...
		coeffs(1)), LineWidth=2, Color=orange, ...
		LineStyle='--', DisplayName='Interpolant');
	
	% Prints coefficients.
	fprintf(fileID, '\n\nLoglog interpolation');
	fprintf(fileID, '\n\nInterpolant: y = %fx + (%f)', ...
		coeffs(1), coeffs(2));

	hold off;
	legend;
	
	if nargin > 0
		bck = [253	246	227] / 255;
	
		set(gca,'color', bck)
		set(legend, 'color', bck)
		
		exportgraphics(gcf, '../gallery/condition.pdf', ...
			'ContentType', 'vector', 'BackgroundColor', bck)

	else
		exportgraphics(gcf, '../gallery/condition.pdf', ...
			'ContentType', 'vector')
	end
end