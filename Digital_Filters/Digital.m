classdef Digital
    %DIGITAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Classification
        Type
        Amax
        Amin
        F
        Filter
        zpoles
    end
    
    methods
        function obj = Digital(Classification, Type, Amax, Amin, F)
            obj.Classification = Classification;
            obj.Type = Type;
            obj.Amax = Amax;
            obj.Amin = Amin;
            obj.F = F;
            obj.F = Digital.PreWarp(obj.F);
            if obj.Classification == "Butterworth"
                obj.Filter = Butterworth(obj.Amax,obj.Amin, obj.F, Type);
            elseif obj.Classification == "Chebyshev"
                obj.Filter = Chebyshev(obj.Amax,obj.Amin, obj.F, Type);
            end
            obj.zpoles = Digital.MyBLT(obj.Filter.poles);
        end
        
        function Display(obj)
            for n = 1:length(obj.zpoles)
                disp('**********************')
                disp(['Section # ' num2str(n)])
                if obj.Type == "Low"
                    disp('Numerator coefficients 1 2 1')
                elseif obj.Type == "High"
                    disp('Numerator coefficients 1 -2 1')
                elseif obj.Type == "Band"
                    disp('Numerator coefficients 1 0 -1')
                elseif obj.Type == "Notch"
                    disp(['Numerator coefficients 1 ' num2str(-2*cos(2*pi*Digital.Unwarp(obj.filter.CF))) ' 1'])
                end
                a = 1;
                b = -2 * real(obj.zpoles(n));
                c = abs(obj.zpoles(n));
                disp(['Denominator coefficients ' num2str(a) ' ' num2str(b) ' ' num2str(c)])
                disp('______________________')
                disp('**********************')
            end
        end
    end
    
    methods(Static)
        function NewFreq=PreWarp(OldFreq)
            NewFreq=2.*tan(2.*pi.*OldFreq./2);
        end
        
        function NewFreq=UnWarp(OldFreq)
            NewFreq=2.*(atan(OldFreq./2))./(2.*pi);
        end
        
        function zpoles=MyBLT(spoles)
            zpoles=(2+spoles)./(2-spoles);
        end
        
    end
end

