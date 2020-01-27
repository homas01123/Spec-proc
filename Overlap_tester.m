
%SEARCH FOR DETECTOR OVERLAP IN SPECTRORADIOMETER%

for n = 1:numel(output)
       
        transitionIndexes = [];
        
        % Loop through all wavelength values, starting from the second.
        for i = 2:numel(output(n).wavelength)
            % If this (the i-th) wavelength value is less than the previous
            % one this indicates a transition between detectors.
            if output(n).wavelength(i) < output(n).wavelength(i-1)
                % Add the index of this wavelength to the list.
                transitionIndexes = [ transitionIndexes, i ];
            end
        end
end



