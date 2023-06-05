% Andrea Di Antonio, 858798.
% Refines the mesh based on the passed marker.
% On marked=[] it refines the mesh by halving all the elements.
function new = refiner(old, marked)
	narginchk(2, 2);
	
	% Checks mode.
	if isempty(marked)
		mode = 1;
	else
		if length(marked) ~= length(old.nodes) - 1; error("Check markers"); end
		mode = 2;
	end

	if mode == 1 % Halves the mesh elements.
		new = builder([old.nodes, old.centres], old.a, old.b);

	else % Refines by marked elements.
		new = builder([old.nodes, ...
			old.centres(marked)], old.a, old.b);

	end
end