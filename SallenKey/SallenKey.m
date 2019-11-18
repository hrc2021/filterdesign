classdef SallenKey
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        poles
        w0
        Q
        R
        R1
        R2
        C
        C1
        C2
        Ra
        Rb
        type
        Gain
    end
    
    methods
        
        function obj = SallenKey(varargin)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.poles = poles(imag(poles) > 1e-13);
            obj.type = type;
            [obj.w0,obj.Q] = Calcw0andQ(obj.poles);
            switch nargin
                case 4 %Case 1 Filter
                    obj.C = varargin{3} .* ones(lenth(obj.Q));
                    obj.Ra = varargin{4} .* ones(lenth(obj.Q));
                case 3 %Case 2 Equation
                    obj.C = varargin{3} .* ones(lenth(obj.Q));
                otherwise
                    disp("You broke it");
            end
        end
        
    end
    methods(Static)
        
        function [w0,Q] = Calcw0andQ(poles)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            w0 = abs(poles);
            Q = 1 ./ ( 2.* abs(cos(angle(poles))));
        end
        
        function R = CalcReq(w0,C)
            R = 1./(w0.*C);
        end
        
        function Rb = CalcRb(Q,Ra)
            ratio = 2-(1./Q);
            Rb = Ra .* ratio;
        end
        
        function [R1,R2] = CalcR1R2(Q,R)
                R2 = 2.*Q.*R;
                R1(k) = R./(2.*Q);
        end
        
        function [C1,C2] = CalcC1C2(Q,C)
                C2 = 2.*Q.*C;
                C1(k) = C./(2.*Q);
        end
        
    end
end

