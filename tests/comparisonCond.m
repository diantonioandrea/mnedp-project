% Andrea Di Antonio, 858798.
function comparisonCond(~)
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/comparisonCond.txt','w');

	% Tests.
	steps = 10;
	sizes = zeros(4, steps);
	conds = zeros(4, steps);

	%% Alpha = 5/3.
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	firstMesh = builder(5);

	fprintf(fileID, 'Condition number, alpha = 5/3.\nSimple.\n');
	
	j = 1;
	[~, A, ~] = solver(firstMesh, f);

	sizes(1, j) = length(firstMesh.elements);
	conds(1, j) = cond(A);

	fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(1, j), conds(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[~, A, ~] = solver(firstMesh, f);

		sizes(1, j) = length(firstMesh.elements);
		conds(1, j) = cond(A);
		
		fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(1, j), conds(1, j));
	end
	
	% Test 2.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[~, A, ~] = solver(secondMesh, f);

	sizes(2, j) = length(secondMesh.elements);
	conds(2, j) = cond(A);

	fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(2, j), conds(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[~, A, ~] = solver(secondMesh, f);

		sizes(2, j) = length(secondMesh.elements);
		conds(2, j) = cond(A);
		
		fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(2, j), conds(2, j));
	end
	%% Alpha = 10.
	f = @(x) f_a(10, x);
	
	% Test 3.
	firstMesh = builder(5);

	fprintf(fileID, '\n\nCondition number, alpha = 10.\nSimple.\n');
	
	j = 1;
	[~, A, ~] = solver(firstMesh, f);
	
	sizes(3, j) = length(firstMesh.elements);
	conds(3, j) = cond(A);

	fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(3, j), conds(3, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[~, A, ~] = solver(firstMesh, f);
		
		sizes(3, j) = length(firstMesh.elements);
		conds(3, j) = cond(A);
		
		fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(3, j), conds(3, j));
	end

	% Test 4.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[~, A, ~] = solver(secondMesh, f);
	
	sizes(4, j) = length(secondMesh.elements);
	conds(4, j) = cond(A);

	fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(4, j), conds(4, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[~, A, ~] = solver(secondMesh, f);
		
		sizes(4, j) = length(secondMesh.elements);
		conds(4, j) = cond(A);
		
		fprintf(fileID, '\nElements: %d\tCond.: %.2e.', ...
			sizes(4, j), conds(4, j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	red = [220, 50, 47] / 255;
	
	tiledlayout(2, 1);

	% Alpha = 5/3.
	nexttile;
	loglog(sizes(1, :), conds(1, :), ...
		DisplayName='Simple, \alpha = 5/3.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(sizes(2, :), conds(2, :), ...
		DisplayName='Adaptive, \alpha = 5/3.', LineWidth=2, ...
		Color=green);

	xlabel("Number of elements");
	ylabel("\chi(A)");

	hold off;
	legend;

	if nargin > 0
		bck = [253	246	227] / 255;
	
		set(gca,'color', bck)
		set(legend, 'color', bck)
	end
	
	% Alpha = 10.
	nexttile;
	loglog(sizes(3, :), conds(3, :), ...
		DisplayName='Simple, \alpha = 10.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(sizes(4, :), conds(4, :), ...
		DisplayName='Adaptive, \alpha = 10.', LineWidth=2, ...
		Color=green);

	xlabel("Number of elements");
	ylabel("\chi(A)");

	hold off;
	legend;
	
	if nargin > 0
		set(gca,'color', bck)
		set(legend, 'color', bck)
		
		exportgraphics(gcf, "../gallery/comparisonCond.pdf", ...
			'ContentType', 'vector', 'BackgroundColor', bck)

	else
		exportgraphics(gcf, "../gallery/comparisonCond.pdf", ...
			'ContentType', 'vector')
	end
end