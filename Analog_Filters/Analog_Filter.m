classdef Analog_Filter
    %ANALOG_FILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Classification %"Butterworth" or "Chebyshev"
        Type %"Low" or "High" or "Band" or "Notch"
        Amax %Value in dB
        Amin %Value in dB
        W % [wp, ws] or [wp1, wp2, ws1 ws2] all in rad/
        DesiredGain % In dB
        order
        poles
        w0
        CF
        Q
    end
    
    methods
        function obj = Analog_Filter(Classification,Type,Amax,Amin, W, varargin)
            %ANALOG_FILTER Construct an instance of this class
            %   obj = Analog_Filter(Classification,Type,Amax,Amin, W, varargin)
            %   varargin{1} = Desired Gain
            
            % Assign Variables
            obj.Classification = Classification;
            obj.Type = Type;
            obj.Amin = Amin;
            obj.Amax = Amax;
            obj.W = W;
            if nargin ==1
                obj.DesiredGain = varargin{1};
            end
            
            % Construct Butterworth
            if obj.Classification == "Butterworth"
                if ((type == "Low") || (type == "High"))
                    % Calc Order
                    obj.order =  Analog_Filter.CalcOrder(obj.Classification, obj.Type, obj.Amax, obj.Amin, obj.W);
                    % Calc w0
                    obj.w0 = Analog_Filter.Calcw0(obj.Type, obj.Amax, obj.W, obj.order);
                    %Calc Poles
                    obj.poles = CalcPolesLPHP(obj.Classification, obj.Amax, obj.order, obj.w0);
                    
                elseif ((type == "Band") || (type == "Notch"))
                    %Enforce Symetry
                    obj.W =
                    %Calc CF
                    obj.CF =
                    % Calc Order
                    obj.order =
                    % Calc Protype w0
                    obj.w0 =
                    % Calc Protype Poles
                    obj.poles =
                    % Calc Band/Notch Poles
                    obj.poles =
                end
            end
            
            %Clean Up Poles
            obj.poles = obj.poles(imag(obj.poles) > -1.0e-13);
            %Calc Final w0
            obj.w0 = abs(obj.poles);
            %Calc Q Value
            obj.Q = 1 ./ ( 2.* abs(cos(pi - angle(obj.poles))));
        end
        
    end
    methods(Static)
        
        function order =  CalcOrder(Classification, Type, Amax, Amin, W)
            if (Type == "Low")
                ratio = W(2)/W(1);
            elseif  (Type == "High")
                ratio = W(1)/W(2);
            elseif  (Type == "Band")
                ratio = (W(4) - W(3)) / (W(2) - W(1));
            elseif  (Type == "Notch")
                ratio = (W(2) - W(1)) / (W(4) - W(3));
            end
            nMin = 10^(Amin/10) -1;
            nMax = 10^(Amax/10) -1;
            if Classification == "Butterworth"
                n = (log(nMin/nMax))/(2*log(ratio));
            elseif Classification == "Chebyshev"
                n = (acosh(sqrt(nMin/nMax))) / (acosh(ratio));
            end
            order = ceil(n);
        end
        
        function w0 = Calcw0(Type, Amax, W, order)
            %Calcw0 Construct an instance of this class
            %   This method will find butterworth w0 for LP/HP
            n = order;
            if (Type == "Low")
                w0 = W(1)/((10^(Amax/10) -1)^(1/(2*n)));
            elseif (Type == "High")
                w0 = W(1)*((10^(Amax/10) -1)^(1/(2*n)));
            elseif (Type == "Band")
                w0 = 1./((10^(Amax/10) -1)^(1/(2*n)));
            elseif (Type == "Notch")
                w0 = 1*((10^(Amax/10) -1)^(1/(2*n)));
            else
                w0 = 0;
            end
        end
        
        function  varargout = CalcPolesLPHP(Classification, Amax, order, w0)
            %varargout{1} = poles
            %varargout{2} = a
            %varargout{3} = b
            
            if Classification == "Butterworth"
                s = CalcS(order, w0);
                varargout{1}= s(real(s) <0);
                
            elseif Classification == "Chebyshev"
                theta = Analog_Fitler.CalcTheta(order);
                [a,b ]= CalcAB(Amax,order);
                varargout{2} = a;
                varargout{3} = b;
                varargout{1} = (-a.*cos(theta) + 1j.*b.*sin(theta)) ;
            end
        end
        
        function s= CalcS(order, w0)
            n = order;
            k = 0:(2*n - 1);
            if (mod(n,2) == 0)
                s = w0*exp (1j *(2*k+1)*pi  /(2*n));
            elseif (mod(n,2) == 1)
                s = w0*exp (1j *pi * k /n);
            else
                s = 0;
            end
        end
        
        function theta = CalcTheta(order)
            n = order;
            if (mod(n,2) == 1)
                k  = 0: (2*n -1);
                s = exp(1j*pi*k /n);
            else
                k = 0:(2*n -1);
                s = exp((1j.* (2.*k +1) .* pi )./ (2*n));
            end
            s = s(real(s) < 0);
            theta = pi - angle(s);
        end
        
        function [a,b] = CalcAB(Amax,order)
            %E
            E = sqrt((10^(Amax/10))-1);
            %A & B
            Ei = 1/E;
            Ei2 = Ei^2;
            Oi = 1/order;
            t1 = (Ei + sqrt(Ei2+1))^Oi;
            t2 = (Ei + sqrt(Ei2+1))^(-1*Oi);
            a = (1/2)*( t1 - t2);
            b = (1/2)*( t1 + t2);
        end
        
    end
end

