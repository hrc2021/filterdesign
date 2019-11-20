classdef BandPass < SallenKey
    %BandPass Finds Values of LP SallenKey
    %   Detailed explanation goes here
    properties
    end
       
    methods
        function obj = BandPass(varargin)
            %BandPass Constructs an instance of this class
            %   Case1 = BandPass(filter,type,C,Ra)
            %   Case2 = BandPass(filter,type,C)
            
            obj = obj@SallenKey(varargin);
            
            switch nargin
                case 4 %Case 1 Filter
                    obj.R = BandPass.CalcReq(obj.w0,obj.C);
                    obj.Rb = BandPass.CalcRb(obj.Q,obj.Ra);
                    normalw0 = obj.w0 ./ obj.filter.CF;
                    obj.Gain = ((2.*sqrt(2)).*obj.Q)-1;
                    obj.Gain = -10.*log10(1+ (obj.Q.^2).*(((1./normalw0) - normalw0).^2)) + 20.*log10( obj.Gain);
                case 3 %Case 2 Equation
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    [obj.R1, obj.R2] = SallenKey.CalcR1R2(obj.Q,obj.R);
                    normalw0 = obj.w0 ./ obj.filter.CF;                    
                    obj.Gain = 2.*(obj.Q.^2);
                    obj.Gain = -10.*log10(1+ (obj.Q.^2).*(((1./normalw0) - normalw0).^2)) + 20.*log10( obj.Gain);
                otherwise
                    disp("You broke it");
            end
        end
    end
    methods(Static)
        
        function R = CalcReq(w0,C)
            R = sqrt(2)./(w0.*C);
        end
        
        function Rb = CalcRb(Q,Ra)
                ratio = 3-(sqrt(2)./Q);
                Rb = Ra.*ratio;
        end
        
    end
end
