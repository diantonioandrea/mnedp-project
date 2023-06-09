% Andrea Di Antonio, 858798.
% Refines the mesh based on the passed marker.
% On marked=[] it refines the mesh by halving all the elements.
function new = refiner(old, marked)
	narginchk(2, 2);
	
	% Checks mode.
	if isempty(marked)
		% Halves the mesh elements.
		nodes = [old.nodes, old.centres];
	else
		if length(marked) ~= length(old.centres)
			error('Check markers')
		end
		% Refines by marked elements.
		nodes = [old.nodes, old.centres(marked)];
	end

	new = builder(nodes, old.a, old.b);
end