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
        a
        b
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
            
            % Construct Filter Based Off of Classification
            if obj.Classification == "Butterworth"
                obj = ButterworthBuilder(obj);
            elseif obj.Classification == "Chebyshev"
                obj = ChebyshevBuilder(obj);
            end
            
            %Clean Up Poles
            obj.poles = obj.poles(imag(obj.poles) > -1.0e-13);
            %Calc Final w0
            obj.w0 = abs(obj.poles);
            %Calc Q Value
            obj.Q = 1 ./ ( 2.* abs(cos(pi - angle(obj.poles))));
            
        end
        
        function obj = BuildButterworth(obj)
            if ((obj.Type == "Low") || (obj.Type == "High"))
                % Calc Order
                obj.order =  Analog_Filter.CalcOrder(obj.Classification, obj.Type, obj.Amax, obj.Amin, obj.W);
                % Calc w0
                obj.w0 = Analog_Filter.Calcw0(obj.Type, obj.Amax, obj.W, obj.order);
                %Calc Poles
                obj.poles = CalcPolesLPHP(obj.Classification, obj.Amax, obj.order, obj.w0);
            elseif ((obj.Type == "Band") || (obj.Type == "Notch"))
                %Enforce Symetry
                obj.W = Analog_Filter.EnforceSym(obj.Type,obj.W);
                %Calc CF
                obj.CF = Analog_Filter.CF(obj.W);
                % Calc Order
                obj.order = Analog_Filter.CalcOrder(obj.Classification, obj.Type, obj.Amax, obj.Amin, obj.W);
                % Calc Protype w0
                obj.w0 = Analog_Filter.Calcw0(obj.Type, obj.Amax, obj.W, obj.order);
                % Calc Protype Poles
                obj.poles = CalcPolesLPHP(obj.Classification, obj.Amax, obj.order, obj.w0);
                % Calc Band/Notch Poles
                obj.poles =  obj.CF.* Analog_Filter.MapBPN(obj.poles, obj.W, obj.CF);
            end
        end
        
        function obj = BuildChebyshev(obj)
            if ((obj.Type == "Low") || (obbj.Type == "High"))
                %Calc Order
                obj.order = Analog_Filter.CalcOrder(obj.Classification, obj.Type, obj.Amax, obj.Amin, obj.W);
                %Calc Poles, A, and B
                [obj.poles,obj.a,obj.b] = CalcPolesLPHP(obj.Classification, obj.Amax, obj.order, obj.w0);
                %High Pass Correction
                if type == "High"
                    obj.poles = 1./obj.poles;
                end
                %De-Normalizing
                obj.poles = obj.W(1) * obj.poles;
            elseif ((obj.Type == "Band") || (obj.Type == "Notch"))
                %Enforce Symetry
                obj.W = Analog_Filter.EnforceSym(obj.Type,obj.W);
                %Calc CF
                obj.CF = Analog_Filter.CF(obj.W);
                % Calc Order
                obj.order = Analog_Filter.CalcOrder(obj.Classification, obj.Type, obj.Amax, obj.Amin, obj.W);
                %Calc Poles, A, and B
                [obj.poles,obj.a,obj.b] = CalcPolesLPHP(obj.Classification, obj.Amax, obj.order, obj.w0);
                %Notch Correction
                if type == "Notch"
                    obj.poles = 1./ obj.poles;
                end
                % Calc Band/Notch Poles
                obj.poles =  obj.CF.* Analog_Filter.MapBPN(obj.poles, obj.W, obj.CF);
            end
        end
        
        function Displayw0andQ(obj)
            if ((obj.Type == "Low") || (obbj.Type == "High"))
                Analog_Filter.Display(obj.Classification, objType, obj.w0, obj.Q)
            elseif ((obj.Type == "Band") || (obj.Type == "Notch"))
            Analog_Filter.Display(obj.Classification, obj.Type, obj.w0, obj.Q, obj.CF)
            end
        end
        
        function GraphResponse(obj)
            %This is just a personal note, I am too lazy to rewrite this as
            % a static function. Maybe I will get around to it eventually
            Hs = ones(1000,length(obj.w0));
            mag = ones(1000,length(obj.w0));
            phase = ones(1000,length(obj.w0));
            phasedeg = ones(1000,length(obj.w0));
            totalresp = ones(1000,1);
            
            for n = 1:length(obj.w0)
                if ((obj.type == "Band") || (obj.type == "Notch"))
                    fcf = log10(obj.CF);
                else
                    fcf = log10((obj.w0(n)));
                end
                fd = fcf  - 1;
                ld = fcf + 1;
                s = logspace(fd,ld,1000);
                w0n = obj.w0(n);
                Qn = obj.Q(n);
                wz = obj.CF;
                if obj.type == "Low"
                    b = w0n^2;
                    a = [1,(w0n/Qn), w0n^2] ;
                elseif obj.type == "High"
                    b = [1, 0, 0];
                    a = [1, (w0n/Qn), w0n^2];
                elseif obj.type == "Band"
                    b = [w0n/sqrt(2),0];
                    a = [1,(w0n/Qn), w0n^2];
                elseif obj.type == "Notch"
                    b = [1,0,wz^2];
                    a = [1,(w0n/Qn),w0n^2];
                else
                    b = 0;
                    a = 0;
                end
                Hs(:,n) = freqs(b,a,s);
                mag(:,n) = 20* log10( abs(Hs(:,n)));
                phase(:,n) = angle(Hs(:,n));
                phasedeg(:,n) = phase(:,n).*180./pi;
                
                totalresp = Hs(:,n) .* totalresp;
            end
            
            totalmag = 20 * log10( abs(totalresp));
            totalphase = angle(totalresp);
            totalphasedeg = totalphase.*180./pi;
            
            disp("Max Response in dB:")
            disp(max(totalmag))
            
            figure
            hold on
            for n = 1:length(obj.w0)
                semilogx(s,mag(:,n));
            end
            semilogx(s,totalmag)
            title('Magnitude Response')
            xlabel('Freq (rad/sec)')
            ylabel('Magnitude')
            set(gca, 'XScale', 'log')
            grid on
            hold off
            
            figure
            hold on
            for n = 1:length(obj.w0)
                semilogx(s,phasedeg(:,n));
            end
            semilogx(s,totalphasedeg)
            title('Angle Response')
            xlabel('Freq (rad/sec)')
            ylabel('Ang (deg)')
            set(gca, 'XScale', 'log')
            grid on
            hold off
            
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
        
        function W = EnforceSym(Type,W)
            %EnforceSym Used in Band/Notch Design
            %   Enforces Symetry on w values
            if Type == "Band"
                if W(4) >  W(1)*W(2)/W(3)
                    W(4) = W(1)*W(2)/W(3);
                elseif W(3) <  W(1)*W(2)/W(4)
                    W(3) = W(1)*W(2)/W(4);
                end
            elseif Type == "Notch"
                if W(1) <  W(3)*W(4)/W(2)
                    W(1) =  W(3)*W(4)/W(2);
                elseif W(2) > W(3)*W(4)/W(1)
                    W(2) = W(3)*W(4)/W(1);
                end
            end
        end
        
        function CF = CalcCF(W)
            %CalcCF Used in Band/Notch Design
            %   Finds Center Frequency
            CF1 = sqrt(W(1)*W(2));
            CF2 = sqrt(W(3)*W(4));
            if not(CF1 == CF2)
                disp("Error! Center Frequency Failed");
                CF = 0;
            else
                CF = CF1;
            end
        end
        
        function poles = MapBPN(poles, W, CF)
            b = (W(2) - W(1)) / CF; % delta-wp / CF
            s1 = (b.*poles./2) + sqrt((((b.*poles).^2)./4) - 1);
            s2 = (b.*poles./2) - sqrt((((b.*poles).^2)./4) - 1);
            s = [s1 s2];
            poles = s(real(s) < 0);
        end
        
        function Display(varargin)
            
            Classifcation = varargin{1};
            Type = varargin{2};
            w0 = varargin{3};
            Q = varargin{4};
            if narargin ==5
                CF= varargin{5};
            end
            
            for n = 1:length(w0)
                disp('______________________')
                disp([Classifcation ' Section ' num2str(n)])
                disp(['     w0  = '  num2str(w0(n)) ' rad/sec'])
                if ((Type == "Band") || (Type == "Notch"))
                    disp(['     (or w0  = '  num2str(w0(n)./CF) '*(Center Frequency))'])
                end
                disp(['     Q  = '  num2str(Q(n)) ])
                disp(['     (or angle  = '  num2str(rad2deg(acos(1./(2*Q(n))))) ' degrees)'])
                if ((Type == "Band") || (Type == "Notch"))
                    disp(['     Wz  = '  num2str(CF)])
                end
                disp('______________________')
                if not(length(w0) == n)
                    disp('**********************')
                end
                
            end
        end
        
    end
end

