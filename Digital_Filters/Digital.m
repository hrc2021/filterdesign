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
        coef
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
            obj.coef = Digital.CoefCalc(obj.zpoles,obj.Type);
        end
        
        function Display(obj)
            for n = 1:length(obj.zpoles)
                disp('**********************')
                disp(['Section # ' num2str(n)])
                disp(['Numerator coefficients ' num2str(obj.coef(1,1,n)) ' ' num2str((obj.coef(1,2,n))) ' ' num2str((obj.coef(1,3,n)))])
                disp(['Denominator coefficients ' num2str(obj.coef(2,1,n)) ' ' num2str((obj.coef(2,2,n))) ' ' num2str((obj.coef(2,3,n)))])
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
        
        function coef = CoefCalc(zpoles,type)
            coef = ones(2,3,length(zpoles));
            for n = 1:length(zpoles)
                if type == "Low"
                    num = [1 2 1];
                elseif type == "High"
                    num = [1 -2 1];
                elseif type == "Band"
                    num = [1 0 -1];
                elseif type == "Notch"
                    num = [1,-2*cos(2*pi*Digital.Unwarp(obj.Filter.CF)),1];
                end
                den = [1,-2 * real(zpoles(n)),abs(zpoles(n))];
                coef(1,:,n) = num;
                coef(2,:,n) = den;
            end
        end
    end
end

