classdef SallenKeyDesignHP
    %SALLENKEYDESIGNHP Given Poles and desire for case 1 (Q-based Gain) or
    % case 2 (Unity (0db) Gain) this function with develope high pass filters of
    % second order for the given poins. Arguements are given (poles, "1" or
    %  "2")
    properties
        poles
        w0
        Q
        oneORtwo
        R
        C
        R1
        R2
        Ra
        Rb
    end
    methods
        function obj = SallenKeyDesignHP(poles,oneORtwo)
            obj.poles = poles(imag(poles) > -1e-13);
            obj.w0 = abs(obj.poles);
            obj.Q = (1./(2*cos(pi -  angle(obj.poles))));
            obj.oneORtwo = oneORtwo;
            if obj.oneORtwo == 2
                obj.C = 10*10^-9;
                obj.R = 1./(obj.w0.*obj.C);
                [obj.R1, obj.R2] = CalcR1R2(obj);
            elseif obj.oneORtwo == 1
                obj.Ra=10000;
                obj.C = 10*10^-9;
                obj.R = 1./(obj.w0.*obj.C);
                obj.Rb = CalcRb(obj);
            end
            DispSpec(obj);
        end
        function DispSpec(obj)
            clc
            disp('Final Sepcs for Sallen-Key Low Pass Filter(s)');
            switch obj.oneORtwo
                case 2
                    disp('Case 2 Filter(s)');
                    disp(' ');
                    for k = 1:length(obj.Q)
                        if (obj.Q(k) == 0.5)
                            disp(['Spec for w0 = ' num2str(obj.w0(k)) ' and Q = ' num2str(obj.Q(k))]);
                            disp('First Order with Gain = 0 dB');
                            disp(['C = ' num2str(obj.C)]);
                            disp(['R = ' num2str(obj.R(k))]);
                        else
                            disp(['Spec for w0 = ' num2str(obj.w0(k)) ' and Q = ' num2str(obj.Q(k))]);
                            disp('Second Order with Gain = 0 dB');
                            disp(['C = ' num2str(obj.C)]);
                            disp(['R1 = ' num2str(obj.R1(k))]);
                            disp(['R2 = ' num2str(obj.R2(k))]);
                            disp(' ');
                        end
                    end
                case 1
                    disp('Case 1 Filter(s)');
                    disp(' ');
                    for k = 1:length(obj.Q)
                        if (obj.Q(k) == 0.5)
                            disp(['Spec for w0 = ' num2str(obj.w0(k)) ' and Q = ' num2str(obj.Q(k))]);
                            disp('First Order with Gain = 0 dB');
                            disp(['C = ' num2str(obj.C)]);
                            disp(['R = ' num2str(obj.R(k))]);
                        else
                            disp(['Spec for w0 = ' num2str(obj.w0(k)) ' and Q = ' num2str(obj.Q(k))]);
                            gain = 1 + (obj.Rb(k)/obj.Ra);
                            dBGain = round(20 * log10(gain),2);
                            disp(['Second Order with Gain = ' num2str(dBGain) ' dB']);                            
                            disp(['C = ' num2str(obj.C)]);
                            disp(['R = ' num2str(obj.R(k))]);
                            disp(['Ra = ' num2str(obj.Ra)]);
                            disp(['Rb = ' num2str(obj.Rb(k))]);
                            disp(' ');
                        end
                    end
            end
        end
        function [R1,R2] = CalcR1R2(obj)
            R1 = zeros(1:length(obj.Q));
            R2 = zeros(1:length(obj.Q));
            for k = 1:length(obj.Q)
                R2(k) = 2*obj.Q(k)*obj.R(k);
                R1(k) = obj.R(k) / (2*obj.Q(k));
            end
        end
        function Rb = CalcRb(obj)
            Rb = zeros(1:length(obj.Q));
            for k = 1:length(obj.Q)
                ratio = 2-(1/obj.Q(k));
                Rb(k) = obj.Ra*ratio;
            end
        end
    end
end
