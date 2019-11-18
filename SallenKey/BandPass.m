classdef BandPass < SallenKey
    %BandPass Finds Values of LP SallenKey
    %   Detailed explanation goes here
       
    methods
        function obj = BandPass(varargin)
            %BandPass Constructs an instance of this class
            %   Case1 = BandPass(poles,type,C,Ra)
            %   Case2 = BandPass(poles,type,C)
            
            obj = obj@SallenKey(varargin);
            
            switch nargin
                case 4 %Case 1 Filter
                    obj.R = BandPass.CalcReq(obj.w0,obj.C);
                    obj.Rb = BandPass.CalcRb(obj.Q,obj.Ra);
                    obj.gain = ((2*sqrt(2)).*obj.Q)-1;
                case 3 %Case 2 Equation
                    obj.R = SallenKey.CalcR(obj.w0,obj.C);
                    [obj.R1, obj.R2] = SallenKey.CalcR1R2(obj.Q,obj.R);
                    obj.gain = 2.*(Q.^2);
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
            Rb = zeros(1:length(Q));
            for k = 1:length(Q)
                ratio = 3-(sqrt(2)/Q(k));
                Rb(k) = Ra*ratio;
            end
        end
        
    end
end
