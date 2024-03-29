classdef HighPass < SallenKey
    %HighPass Finds Values of LP SallenKey
    %   Detailed explanation goes here
    
    methods
        function obj = HighPass(varargin)
            %HighPass Constructs an instance of this class
            %   Case1 = HighPass(filterobj,type,C,Ra)
            %   Case2 = HighPass(filterobj,type,C)
            
            obj = obj@SallenKey(varargin);
            
            switch nargin
                case 4 %Case 1 Filter
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    obj.Rb = SallenKey.CalcRb(obj.Q,obj.Ra);
                    obj.Gain = 1 + (obj.Ra ./ obj.Rb);
                    obj.Gain =  20.*log10( obj.Gain);
                case 3 %Case 2 Equation
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    [obj.R1, obj.R2] = SallenKey.CalcR1R2(obj.Q,obj.R);
                    obj.Gain = 1 .* ones(1,length(obj.Q));
                    obj.Gain =  20.*log10( obj.Gain);
                otherwise
                    disp("You broke it");
            end
        end
    end
end

