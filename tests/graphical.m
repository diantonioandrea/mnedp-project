% Andrea Di Antonio, 858798.
function graphical
    % FEM.
	addpath('../src')

	% Functions.
    u_a = @(a, x) x.^(a) .* (1 - x); % u';
	f_a = @(a, x) - a * (a - 1) * x.^(a - 2) + ...
		(a + 1) * a * x.^(a - 1); % -u'' from Poisson.

    %% Alpha = 5/3.
    u = @(x) u_a(5/3, x);
	f = @(x) f_a(5/3, x);
    
    uMesh = builder(2048);
    [uh, ~, ~] = solver(uMesh, f);
    
    green = [133, 153, 0] / 255;
	red = [220, 50, 47] / 255;
    
    tiledlayout(2, 1);
    nexttile;

    plot(uMesh.nodes, uh, ...
		DisplayName='u_h(x), alpha = 5/3', LineWidth=1, ...
		Color=red);
    hold on;

    plot(uMesh.nodes, u(uMesh.nodes), ...
		DisplayName='u(x), alpha = 5/3', LineWidth=1, ...
		Color=green);

    hold off;
    legend;

    %% Alpha = 10.
    u = @(x) u_a(10, x);
	f = @(x) f_a(10, x);
    
    [uh, ~, ~] = solver(uMesh, f);
    
    nexttile;

    plot(uMesh.nodes, uh, ...
		DisplayName='u_h(x), alpha = 10', LineWidth=1, ...
		Color=red);
    hold on;

    plot(uMesh.nodes, u(uMesh.nodes), ...
		DisplayName='u(x), alpha = 10', LineWidth=1, ...
		Color=green);

    hold off;
    legend;

    saveas(gcf, "../gallery/graphical", "jpeg")
end