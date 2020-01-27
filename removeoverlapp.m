function [output, firstSWIRIndex, secondSWIRIndex] = removeoverlapp(input, joinWavelength1,joinWavelength2)
for n = 1:numel(input)
       transitionIndexes = []; 
        % Loop through all wavelength values, starting from the second.
        for i = 2:numel(input(n).wavelength)
            % If this (the i-th) wavelength value is less than the previous
            % one this indicates a transition between detectors.
            if input(n).wavelength(i) < input(n).wavelength(i-1)
                % Add the index of this wavelength to the list.
                transitionIndexes = [ transitionIndexes, i ];
            end
        end
                
        if isempty(transitionIndexes)
            error('No transition wavelengths were found in spectrum number %d', n);
        end

        % There are two transition wavelength in the spectrum, so
        % the spectrum can now be divided into three spectral regions. These
        % will be called VNIR and SWIR1 and SWIR2 (although the function can in
        % general be applied to any transition).
        firstSWIRIndex = transitionIndexes(1);
        secondSWIRIndex = transitionIndexes(2);
        
        % SEPARATE REGIONS
        % Separate the VNIR and SWIR spectral regions.
        wavelengthVNIR = input(n).wavelength(1:firstSWIRIndex - 1);
        dataVNIR = input(n).data(1:firstSWIRIndex - 1);
        wavelengthSWIR1 = input(n).wavelength(firstSWIRIndex:secondSWIRIndex - 1);
        dataSWIR1 = input(n).data(firstSWIRIndex:secondSWIRIndex - 1);
        wavelengthSWIR2 = input(n).wavelength(secondSWIRIndex:end);
        dataSWIR2 = input(n).data(firstSWIRIndex:end);

        % JOIN REGIONS
        % Join the spectral regions at the specified wavelength.
        
        % Find the wavelength range of the overlap region.
        overlapRegion1 = [ wavelengthSWIR1(1), wavelengthVNIR(end) ];
        overlapRegion2 = [ wavelengthSWIR2(1), wavelengthSWIR1(end) ];
        
        % Check that the specified join wavelength is within the overlap region.
%         if joinWavelength < overlapRegion(1) || joinWavelength > overlapRegion(2)
%             error('The specified join wavelength %.1f nm does not lie within the overlap region (%.1f-%.1f) nm of spectrum number %d.', joinWavelength, overlapRegion(1), overlapRegion(2), n);
%         end
        
        % Create the joined wavelength and data.
        wavelengthJoined = [ wavelengthVNIR(wavelengthVNIR < joinWavelength1); wavelengthSWIR1(wavelengthSWIR1 >= joinWavelength1 & wavelengthSWIR1 < joinWavelength2); wavelengthSWIR2(wavelengthSWIR2 >= joinWavelength2) ];
        dataJoined = [ dataVNIR(wavelengthVNIR < joinWavelength1); dataSWIR1(wavelengthSWIR1 >= joinWavelength1 & wavelengthSWIR1 < joinWavelength2); dataSWIR2(wavelengthSWIR2 >= joinWavelength2) ];

        % CREATE THE OUTPUT SPECTRUM
        % Copy the input spectrum structure, then overwrite wavelength and
        % data fields with the new values.
        output(n) = input(n);
        output(n).wavelength = wavelengthJoined;
        output(n).data = dataJoined;
end
end