function marked = marker(mesh, f)
	[u, ~, ~] = solver(mesh, f);
	estimates = zeros(1, length(mesh.elements));

	for j = 1:length(estimates)
		h = mesh.elements(j, 3);
		xs = mesh.nodes(j);
		xd = mesh.nodes(j + 1);

		% Integral estimate.
		estimates(j) = .5 * ((f(xs) + u(j))^2 + ...
			(f(xd) + u(j + 1))^2) * h^3;

		% gradJump estimate.
		estimates(j) = estimates(j) + .5 * h * ...
			(absGradJump(mesh, u, xs) - ...
			absGradJump(mesh, u, xd));
	end

	marked = estimates >= min(maxk(estimates, ...
		fix(length(estimates)/4)));
end

function jump = gradJump(mesh, u, x)
	if x == mesh.a || x == mesh.b; jump = 0; return; end
	ind = find(mesh.nodes == x);

	hs = mesh.elements(ind - 1, 3);
	hd = mesh.elements(ind, 3);

	gs = (u(ind) - u(ind - 1)) / hs;
	gd = (u(ind + 1) - u(ind)) / hd;

	jump = gd - gs;
end

function jump = absGradJump(mesh, u, x)
	jump = abs(gradJump(mesh, u, x));
end