function new = refiner(old, marked)
	narginchk(2, 2);
	
	% Checks mode.
	if isempty(marked)
		mode = 1;
	else 
		mode = 2; 
	end

	if mode == 1 % Halves the mesh elements.
		new = builder(cat(2, old.nodes, old.centres), old.a, old.b);

	else % Refines by marked elements.
		new = builder(cat(2, old.nodes, ...
			old.centres(marked)), old.a, old.b);

	end
end