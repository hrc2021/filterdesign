classdef Digital
    %DIGITAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        samplingFreq
        warpFreq
        zpoles
    end
    
    methods
        function obj = Digital(freq)
          obj.warpFreq = prewarp(freq);
          
        end

    end
    methods(Static)
        function warpFreq = prewarp(freq)
            warpFreq = freq;
    end
end

