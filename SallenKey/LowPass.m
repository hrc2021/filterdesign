classdef LowPass < SallenKey
    %LowPass Finds Values of LP SallenKey
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = LowPass(varargin)
            %LowPass Constructs an instance of this class
            %   Case1 = LowPass(poles,type,C,Ra)
            %   Case2 = LowPass(poles,type,C)
            
            obj = obj@SallenKey(varargin);
            
            switch nargin
                case 4 %Case 1 Filter
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    obj.Rb = SallenKey.CalcRb(obj.Q,obj.Ra);
                    obj.gain = 1 + (obj.Ra ./ obj.Rb);
                case 3 %Case 2 Equation
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    [obj.C1, obj.C2] = SallenKey.CalcC1C2(obj.Q,obj.C);
                    obj.gain = 1 * ones(lenth(obj.Q));
                otherwise
                    disp("You broke it");
            end
        end
    end
end

