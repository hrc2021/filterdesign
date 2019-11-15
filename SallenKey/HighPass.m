classdef HighPass < SallenKey
    %HighPass Finds Values of LP SallenKey
    %   Detailed explanation goes here
       
    methods
        function obj = HighPass(varargin)
            %HighPass Constructs an instance of this class
            %   Case1 = HighPass(poles,type,C,Ra)
            %   Case2 = HighPass(poles,type,C)
            
            obj = obj@SallenKey(varargin{1}, varargin{2});
            
            switch nargin
                case 4 %Case 1 Filter
                    obj.C = varargin{3};
                    obj.Ra = varargin{4};
                    obj.R = SallenKey.CalcReq(obj.w0,obj.C);
                    obj.Rb = SallenKey.CalcRb(obj.Q,obj.Ra);
                case 3 %Case 2 Equation
                    obj.C = varargin{3};
                    obj.R = SallenKey.CalcR(obj.w0,obj.C);
                    [obj.R1, obj.R2] = SallenKey.CalcR1R2(obj.Q,obj.R);
                otherwise
                    disp("You broke it");
            end
        end
    end
end

