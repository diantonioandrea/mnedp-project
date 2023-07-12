% Andrea Di Antonio, 858798.
function comparisonCond
	%% Initialization
	% FEM.
	addpath('../src')

	% Functions.
	up_a = @(a, x) a * x.^(a - 1) - (a + 1) * x.^a; % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

	% Output.
	fileID = fopen('../results/comparisonCond.txt','w');

	% Tests.
	steps = 10;
	conds = zeros(4, steps);
	errors = zeros(4, steps);

	%% Alpha = 5/3.
	up = @(x) up_a(5/3, x);
	f = @(x) f_a(5/3, x);
	
	% Test 1.
	firstMesh = builder(5);

	fprintf(fileID, 'Errors evaluation, alpha = 5/3.\nSimple.\n');
	
	j = 1;
	[uh, A, ~] = solver(firstMesh, f);

	errors(1, j) = errorEstimate(firstMesh, up, uh);
	conds(1, j) = cond(A);

	fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(1, j), errors(1, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, A, ~] = solver(firstMesh, f);

		errors(1, j) = errorEstimate(firstMesh, up, uh);
		conds(1, j) = cond(A);
		
		fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(1, j), errors(1, j));
	end
	
	% Test 2.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[uh, A, ~] = solver(secondMesh, f);

	errors(2, j) = errorEstimate(secondMesh, up, uh);
	conds(2, j) = cond(A);

	fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(2, j), errors(2, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, A, ~] = solver(secondMesh, f);

		errors(2, j) = errorEstimate(secondMesh, up, uh);
		conds(2, j) = cond(A);
		
		fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(2, j), errors(2, j));
	end
	%% Alpha = 10.
	up = @(x) up_a(10, x);
	f = @(x) f_a(10, x);
	
	% Test 3.
	firstMesh = builder(5);

	fprintf(fileID, '\n\nErrors evaluation, alpha = 10.\nSimple.\n');
	
	j = 1;
	[uh, A, ~] = solver(firstMesh, f);
	
	errors(3, j) = errorEstimate(firstMesh, up, uh);
	conds(3, j) = cond(A);

	fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(3, j), errors(3, j));

	for j = 2:steps
		firstMesh = refiner(firstMesh, []);
		[uh, A, ~] = solver(firstMesh, f);
		
		errors(3, j) = errorEstimate(firstMesh, up, uh);
		conds(3, j) = cond(A);
		
		fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(3, j), errors(3, j));
	end

	% Test 4.
	secondMesh = builder(5);

	fprintf(fileID, '\n\nAdaptive.\n');

	j = 1;
	[uh, A, ~] = solver(secondMesh, f);
	
	errors(4, j) = errorEstimate(secondMesh, up, uh);
	conds(4, j) = cond(A);

	fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(4, j), errors(4, j));

	for j = 2:steps
		marked = marker(secondMesh, f);
		secondMesh = refiner(secondMesh, marked);
		[uh, A, ~] = solver(secondMesh, f);
		
		errors(4, j) = errorEstimate(secondMesh, up, uh);
		conds(4, j) = cond(A);
		
		fprintf(fileID, '\nCondition number: %d\tError: %e.', ...
			conds(4, j), errors(4, j));
	end

	%% Graphics.
	
	green = [133, 153, 0] / 255;
	red = [220, 50, 47] / 255;
	
	tiledlayout(2, 1);

	% Alpha = 5/3.
	nexttile;
	loglog(conds(1, :), errors(1, :), ...
		DisplayName='Simple, \alpha = 5/3.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(conds(2, :), errors(2, :), ...
		DisplayName='Adaptive, \alpha = 5/3.', LineWidth=2, ...
		Color=green);

	xlabel("Condition number");
	ylabel("|u - u_h|_{1, \Omega}");

	hold off;
	legend;
	
	% Alpha = 10.
	nexttile;
	loglog(conds(3, :), errors(3, :), ...
		DisplayName='Simple, \alpha = 10.', LineWidth=2, ...
		Color=red);
	hold on;

	loglog(conds(4, :), errors(4, :), ...
		DisplayName='Adaptive, \alpha = 10.', LineWidth=2, ...
		Color=green);

	xlabel("Condition number");
	ylabel("|u - u_h|_{1, \Omega}");

	hold off;
	legend;

	saveas(gcf, "../gallery/comparisonCond", "jpeg")
end

function err = errorEstimate(mesh, up, uh)
	err = 0;

	for j = 1:length(mesh.nodes) - 1
		h = mesh.elements(j, 3);
		xs = mesh.nodes(j);
		xd = mesh.nodes(j + 1);

		gh = (uh(j + 1) - uh(j)) / h;

		err = err + .5 * h * ((up(xs) - gh)^2 + ...
			(up(xd) - gh)^2);
	end

	err = sqrt(err);
end