function mesh = builder(nodes, a, b)
	% Input checks.
	narginchk(1, 3);

	% a, b checks.
	if nargin == 2
		error("Must set both a and b or none of them.")
	end
	
	if nargin == 1; a = 0; b = 1; end
	if nargin == 3 && a >= b; error("Set error."); end

	% Builds the mesh nodes.
	if length(nodes) == 1
		if nodes < 0; error("Nodes error"); end
		mesh.nodes = linspace(a, b, nodes);
	else
		mesh.nodes = sort(nodes);
	end

	% Start and end.
	mesh.a = a;
	mesh.b = b;

	% Defines the elements.
	mesh.elements = zeros(length(mesh.nodes) - 1, 3);
	mesh.elements(:, 1) = mesh.nodes(1:end-1);
	mesh.elements(:, 2) = mesh.nodes(2:end);
	mesh.elements(:, 3) = mesh.elements(:, 2) - mesh.elements(:, 1);

	% Central points.
	mesh.centres = .5 * (mesh.elements(:, 2) + mesh.elements(:, 1))';
end