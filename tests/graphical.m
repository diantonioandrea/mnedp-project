% Andrea Di Antonio, 858798.
function graphical(~)
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
	orange = [203, 75, 22] / 255;
    
    tiledlayout(2, 1);
    nexttile;
	
	plot(uMesh.nodes, u(uMesh.nodes), ...
		DisplayName='u(x), \alpha = 5/3', LineWidth=2, ...
		Color=green);
    hold on;

    plot(uMesh.nodes, uh, ...
		DisplayName='u_h(x), \alpha = 5/3', LineWidth=2, ...
		Color=orange,LineStyle='--');

	xlabel("x");
	ylabel("u(x), u_h(x)");

    hold off;
    legend(Location='northwest');

	if nargin > 0
		bck = [253	246	227] / 255;
	
		set(gca,'color', bck)
		set(legend, 'color', bck)
	end

    %% Alpha = 10.
    u = @(x) u_a(10, x);
	f = @(x) f_a(10, x);
    
    [uh, ~, ~] = solver(uMesh, f);
    
    nexttile;

    plot(uMesh.nodes, u(uMesh.nodes), ...
		DisplayName='u(x), \alpha = 10', LineWidth=2, ...
		Color=green);
    hold on;
	
	plot(uMesh.nodes, uh, ...
		DisplayName='u_h(x), \alpha = 10', LineWidth=2, ...
		Color=orange,LineStyle='--');

	xlabel("x");
	ylabel("u(x), u_h(x)");

    hold off;
    legend(Location='northwest');
	
	if nargin > 0
		set(gca,'color', bck)
		set(legend, 'color', bck)
		
		exportgraphics(gcf, "../gallery/graphical.pdf", ...
			'ContentType', 'vector', 'BackgroundColor', bck)

	else
		exportgraphics(gcf, "../gallery/graphical.pdf", ...
			'ContentType', 'vector')
	end
end