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
        
        function obj = SallenKey(poles,type)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.poles = poles;
            obj.type = type;
            [obj.w0,obj.Q] = Calcw0andQ(obj.poles);
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
            Rb = zeros(1:length(Q));
            for k = 1:length(Q)
                ratio = 2-(1/Q(k));
                Rb(k) = Ra*ratio;
            end
        end
        
        function [R1,R2] = CalcR1R2(Q,R)
            R1 = zeros(1:length(Q));
            R2 = zeros(1:length(Q));
            for k = 1:length(obj.Q)
                R2(k) = 2*Q(k)*R;
                R1(k) = R / (2*Q(k));
            end
        end
        
        function [C1,C2] = CalcC1C2(Q,C)
            C1 = zeros(1:length(Q));
            C2 = zeros(1:length(Q));
            for k = 1:length(Q)
                C2(k) = 2*Q(k)*C;
                C1(k) = C / (2*Q(k));
            end
        end
        
    end
end

