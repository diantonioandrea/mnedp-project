function marked = marker(mesh, f)
	[uh, ~, ~] = solver(mesh, f);
	estimates = zeros(1, length(mesh.elements));

	for j = 1:length(estimates)
		h = mesh.elements(j, 3);
		xs = mesh.nodes(j);
		xd = mesh.nodes(j + 1);

		% Integral estimate.
		% uh'' = 0.
		estimates(j) = .5 * (f(xs)^2 + ...
			f(xd)^2) * h^3;

		% gradJump estimate.
		estimates(j) = estimates(j) + .5 * h * ...
			(absGradJump(mesh, uh, xs) - ...
			absGradJump(mesh, uh, xd));
	end

	marked = estimates >= min(maxk(estimates, ...
		fix(length(estimates)/4)));
end

function jump = gradJump(mesh, uh, x)
	if x == mesh.a || x == mesh.b; jump = 0; return; end
	ind = find(mesh.nodes == x);

	hs = mesh.elements(ind - 1, 3);
	hd = mesh.elements(ind, 3);

	gs = (uh(ind) - uh(ind - 1)) / hs;
	gd = (uh(ind + 1) - uh(ind)) / hd;

	jump = gd - gs;
end

function jump = absGradJump(mesh, uh, x)
	jump = abs(gradJump(mesh, uh, x));
end