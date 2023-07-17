% Andrea Di Antonio, 858798.
% Returns the marked elements of a mesh by evaluating the error
% estimator on every element and picking the 25% highest values.
function marked = marker(mesh, f, percentage)
narginchk(2, 3);
	if nargin <= 2 || isempty(precentage); percentage = 25; end
	if nargin == 3
		if percentage <= 0 || percentage > 100
			error('wrong percentage');
		end
	end

	[estimates, ~] = estimate(mesh, f);
	marked = estimates >= prctile(estimates, 100 - percentage);
end