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
            
            %Var Set
            obj.Classification = Classification;
            obj.Type = Type;
            obj.Amax = Amax;
            obj.Amin = Amin;
            obj.F = F;
            
            %Prewarp
            obj.F = Digital.PreWarp(obj.F);
            
            %Get your Poles
            if obj.Classification == "Butterworth"
                obj.Filter = Butterworth(obj.Amax,obj.Amin, obj.F, Type);
            elseif obj.Classification == "Chebyshev"
                obj.Filter = Chebyshev(obj.Amax,obj.Amin, obj.F, Type);
            end
            
            %Get z-poles
            obj.zpoles = Digital.MyBLT(obj.Filter.poles);
            
            %Get Coefficients
            obj.coef = CoefCalc(obj);
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
        
        function coeff = CoefCalc(obj)
            
            coeff = ones(2,3,length(obj.zpoles));
            
            %For all your pole sections
            for n = 1:length(obj.zpoles)
                
                %First Order Section
                if (abs(imag(obj.zpoles(n))) < 1e-4)
                    if obj.Type == "Low"
                        num = [1 1];
                    elseif obj.Type == "High"
                        num = [1 -1];
                    end
                    den = [1,-1*real(obj.zpoles(n))];
                    coeff(1,:,n) = [num 0];
                    coeff(2,:,n) = [den 0];
                    
                    %Second Order Section
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
                    coeff(1,:,n) = num;
                    coeff(2,:,n) = den;
                end
            end
            
        end
        
        function GraphResp(obj)
            Digital.Graph(obj.coef)
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
        
        function realfreq = CalcRealFreq(WarpedFreq,SamplingFreq)
            % WarpedFreq is typically obj.F
            % SamplingFreq is Fs
            realfreq = (WarpedFreq .* SamplingFreq) ./ (2*pi);
        end
        
        function Graph(Hzcoef)
            
            fdivfs = 0:0.01:0.5;
            
            z = exp(1j*2*pi*(fdivfs));
            
            Hzint = ones(length(Hzcoef(1,1,:)), length(z));
            for n = 1:length(Hzcoef(1,1,:))
                Hznum = Hzcoef(1,1,n) + Hzcoef(1,2,n).*(z.^-1) +Hzcoef(1,3,n).*(z.^-2);
                Hzden = Hzcoef(2,1,n) + Hzcoef(2,2,n).*(z.^-1) +Hzcoef(2,3,n).*(z.^-2);
                Hzint(n,:) = Hznum./Hzden;
            end
            
            
            Hz = ones(1,length(Hzint(1,:)));
            for n = 1:length(Hzint(1,:))
                for i = 1:length(Hzint(:,1))
                    Hz(n) = Hz(n)*(Hzint(i,n));
                end
            end
            close all
            clf
            
            plot(fdivfs,20*log10(abs(Hz)));grid
        end
    end
end

