% Andrea Di Antonio, 858798.
% Estimates the H1 seminorm of (u - u_h).
function err = errorEstimate(mesh, up, uh)
	xs = mesh.nodes(1:end - 1);
	xd = mesh.nodes(2:end);
	mds = (xs + xd) / 2;

	h = mesh.elements(:, 3)';
	gh = diff(uh) ./ h;
	
	% Uses Simpson's 1/3 rule.
	errors = h / 6 .* ((up(xs) - gh) .^ 2 + ...
		+ 4 * (up(mds) - gh) .^ 2 + (up(xd) - gh) .^ 2);

	err = sqrt(sum(errors));
end