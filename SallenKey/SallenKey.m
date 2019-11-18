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
            varargin = varargin{1};
            poles = varargin{1};
            obj.poles = poles((imag(poles)) > -1e-13);
            obj.type = varargin{2};
            obj.C = varargin{3} .* ones(1,length(obj.poles));
            [obj.w0,obj.Q] = SallenKey.Calcw0andQ(obj.poles);
            switch length(varargin)
                case 4 %Case 1 Filter
                    obj.Ra = varargin{4} .* ones(1,length(obj.Q));
                    obj.type = "Case 1 Filter(s)";
                case 3 %Case 2 Equation
                    obj.C = varargin{3} .* ones(1,length(obj.Q));
                    obj.type = "Case 2 Filter(s)";
                otherwise
                    disp("You broke it");
            end
        end
        
        function DisplaySpec(obj)
            clc
            disp(obj.type)
            if obj.type == "Case 1 Filter(s)"
                for n = 1:length(obj.Q)
                    disp(' ')
                    disp(['For w0: ' num2str(obj.w0(n)) ' & Q: ' num2str(obj.Q(n))])
                    if round(obj.Q(n),2) == 0.5
                        disp('First Order Filter')
                        disp(['R1: ' num2str(obj.R(n)) ' (Assuming you want 0 dB Gain)'])
                        disp(['R2: ' num2str(obj.R(n))])
                        disp(['C: ' num2str(obj.C(n))])
                    else
                        disp('Second Order Filter')
                        disp(['R: ' num2str(obj.R(n))])
                        disp(['C: ' num2str(obj.C(n))])
                        disp(['Ra: ' num2str(obj.Ra(n))])
                        disp(['Rb: ' num2str(obj.Rb(n))])
                        disp(['Gain: ' num2str(obj.Gain(n))])
                    end
                end
            else
                for n = 1:length(obj.Q)
                    disp(' ')
                    disp(['For w0 =' obj.w0(n) ' & Q = ' obj.Q(n)])
                    if round(obj.Q(n),2) == 0.5
                        disp('First Order Filter')
                        disp(['R1: ' num2str(obj.R(n)) ' (Assuming you want 0 dB Gain)'])
                        disp(['R2: ' num2str(obj.R(n))])
                        disp(['C: ' num2str(obj.C(n))])
                    else
                        classtype = class(obj);
                        if classtype == 'LowPass'
                            disp(['R: ' num2str(obj.R(n))])
                            disp(['C1: ' num2str(obj.C1(n))])
                            disp(['C2: ' num2str(obj.C2(n))])
                            disp(['Gain: ' num2str(obj.Gain(n))])
                        elseif classtype == 'HighPass'
                            disp(['R1: ' num2str(obj.R1(n))])
                            disp(['R2: ' num2str(obj.R2(n))])
                            disp(['C: ' num2str(obj.C(n))])
                            disp(['Gain: ' num2str(obj.Gain(n))])
                        elseif classtype == 'BandPass'
                            disp(['R1: ' num2str(obj.R1(n))])
                            disp(['R2: ' num2str(obj.R2(n))])
                            disp(['C: ' num2str(obj.C(n))])
                            disp(['Gain: ' num2str(obj.Gain(n))])
                        end
                    end
                end
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
    
