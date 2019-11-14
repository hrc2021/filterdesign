classdef Butterworth_Filter
    %BUTTERWORTH_FILTER 
    %   Used in Linear Circuit Filter Design
    
    properties
        Amax
        Amin
        w % [wp, ws] or [wp1, wp2, ws1 ws2]
        type %"Low" or "High" or "Band" or "Notch"
        order
        poles
        w0
        CF
        Q
    end
    
    methods
        
        function obj = Butterworth_Filter(Amax, Amin, w, type)
            %BUTTERWORTH_FILTER Construct an instance of this class
            %   This constructer will find all values corrisponding with
            %   filter design.
            obj.Amin = Amin;
            obj.Amax = Amax;
            obj.w = w;
            obj.type = type;
            if ((type == "Low") || (type == "High"))
                obj.order = Butterworth_Filter.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                obj.w0 = Butterworth_Filter.Calcw0(obj.Amax, obj.w, obj.order, obj.type);
                obj.poles = obj.w0.*Butterworth_Filter.CalcPolesLPHP(obj.order);
            elseif ((type == "Band") || (type == "Notch"))
                obj.w = Butterworth_Filter.EnforceSym(obj.w, obj.type);
                obj.CF = Butterworth_Filter.CalcCF(obj.w);
                obj.order = Butterworth_Filter.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                obj.poles = Butterworth_Filter.CalcPolesLPHP(obj.order);
                obj.poles = obj.CF.*Butterworth_Filter.Map(obj.poles, obj.w, obj.CF);
            end
            obj.w0 = abs(obj.poles);
            obj.Q = 1 ./ ( 2.* abs(cos(angle(obj.poles))));
        end
        
    end
    
    methods(Static)
        
        function order =  CalcOrder(Amax, Amin, w, type)
            %CalcOrder Calculates Order Given Arugments
            %   Method will return real order for Low and High Pass.
            %   If used for Band or Notch, it will return 1/2 of order.
            if (type == "Low")
                ratio = w(2)/w(1);
            elseif  (type == "High")
                ratio = w(1)/w(2);
            elseif  (type == "Band")
                ratio = (w(4) - w(3)) / (w(2) - w(1));
            elseif  (type == "Notch")
                ratio = (w(2) - w(1)) / (w(4) - w(3));
            end
            nMin = 10^(Amin/10) -1;
            nMax = 10^(Amax/10) -1;
            n = (log(nMin/nMax))/(2*log(ratio));
            order = ceil(n);
        end
        
        function w0 = Calcw0(Amax, w, order, type)
            %Calcw0 Construct an instance of this class
            %   This method will find butterworth w0 for LP/HP
            n = order;
            if (type == "Low")
                w0 = w(1)/((10^(Amax/10) -1)^(1/(2*n)));
            elseif (type == "High")
                w0 = w(1)*((10^(Amax/10) -1)^(1/(2*n)));
            else 
                w0 = 0;
            end
        end
        
        function poles = CalcPolesLPHP(order)
            %CalcPolesLPHP Method calc's poles for LP/HP
            %   Assuming w0 = 1
            n = order;
            k = 0:(2*n - 1);
            if (mod(n,2) == 0)
                s = exp (1j *(2*k+1)*pi  /(2*n));
            elseif (mod(n,2) == 1)
                s = exp (1j *pi * k /n);
            else 
                s = 0;
            end
            poles = s(real(s) <0);
        end
        
        function w = EnforceSym(w,type)
            %EnforceSym Used in Band/Notch Design
            %   Enforces Symetry on w values
            if type == "Band"
                if w(4) >  w(1)*w(2)/w(3)
                    w(4) = w(1)*w(2)/w(3);
                elseif w(3) <  w(1)*w(2)/w(4)
                    w(3) = w(1)*w(2)/w(4);
                end
            elseif type == "Notch"
                if w(1) <  w(3)*w(4)/w(2)
                    w(1) =  w(3)*w(4)/w(2);
                elseif w(2) <  w(3)*w(4)/w(1)
                    w(2) = w(3)*w(4)/w(1);
                end
            end
            if not(sqrt(w(1)*w(2)) == sqrt(w(3)*w(4)))
                disp("Error! Enforced Sysmtry Failed!")
                w = [-1 -1 -1 -1];
            end
        end
        
        function CF = CalcCF(w)
            %CalcCF Used in Band/Notch Design
            %   Finds Center Frequency
            CF1 = sqrt(w(1)*w(2));
            CF2 = sqrt(w(3)*w(4));
            if not(CF1 == CF2)
                disp("Error! Center Frequency Failed");
                CF = 0;
            else
                CF = CF1;
            end
        end
        
        function poles = Map(poles, w, CF)
            %Map Used in Band/Notch Design
            %   Using LP/HP poles to find actual poles for Band/Notch
            %   design
            b = (w(2) - w(1)) / CF; % delta-wp / CF
            s1 = (b.*poles./2) + sqrt((((b.*poles).^2)./2) - 1);
            s2 = (b.*poles./2) - sqrt((((b.*poles).^2)./2) - 1);
            s = [s1 s2];
            poles = s(real(s) < 0);
        end
                
    end
end

