% Andrea Di Antonio, 858798
% Runs every test.
function runAll(~)
	fprintf('Running all scripts')
	
	if nargin == 0
		reliability;
		close(gcf);

		graphical;
		close(gcf);

		errorTrend;
		close(gcf);

		condition;
		close(gcf);

		comparisonCond;
		close(gcf);

		comparison;
		close(gcf);

	else
		reliability(1);
		close(gcf);

		graphical(1);
		close(gcf);

		errorTrend(1);
		close(gcf);

		condition(1);
		close(gcf);

		comparisonCond(1);
		close(gcf);

		comparison(1);
		close(gcf);
	end

	fprintf('\nDone\n')
end