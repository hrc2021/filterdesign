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
            obj.coef = CoefCalc(obj);
        end
        
        function Display(obj)
            for n = 1:length(obj.zpoles)
                disp('**********************')
                disp(['Section # ' num2str(n)])
                disp(['Numerator coefficients ' num2str(obj.coef(n,1,1)) ' ' num2str((obj.coef(n,1,2))) ' ' num2str((obj.coef(n,1,3)))])
                disp(['Denominator coefficients ' num2str(obj.coef(n,2,1)) ' ' num2str((obj.coef(n,2,2))) ' ' num2str((obj.coef(n,2,3)))])
                disp('______________________')
                disp('**********************')
            end
        end
        
        function coeff = CoefCalc(obj)
            for n = 1:length(obj.zpoles)
                if abs(imag(obj.zpoles(n))) < 1e-4
                    if obj.Type == "Low"
                        num = [1 1];
                    elseif obj.Type == "High"
                        num = [1 -1];
                    end
                    den = [1,-1* real(obj.zpoles(n))];
                    coeff(n,1,:) = [num 0 ];
                    coeff(n,2,:) = [den 0];
                else
                    if obj.Type == "Low"
                        num = [1 2 1];
                    elseif obj.Type == "High"
                        num = [1 -2 1];
                    elseif obj.Type == "Band"
                        num = [1 0 -1];
                    elseif obj.Type == "Notch"
                        num = [1,-2*cos(2*pi*Digital.UnWarp(obj.Filter.CF)),1];
                    end
                    den = [1,-2 * real(obj.zpoles(n)),(abs(obj.zpoles(n))).^2];
                    coeff(n,1,:) = num;
                    coeff(n,2,:) = den;
                end
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

