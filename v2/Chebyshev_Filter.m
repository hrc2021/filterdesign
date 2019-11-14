classdef Chebyshev_Filter
    %Chebyshev_FILTER
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
        
        function obj = Chebyshev_Filter(Amax, Amin, w, type)
            %Chebyshev_Filter Construct an instance of this class
            %   This constructer will find all values corrisponding with
            %   filter design.
            obj.Amin = Amin;
            obj.Amax = Amax;
            obj.w = w;
            obj.type = type;
            if ((type == "Low") || (type == "High"))
                obj.order = Chebyshev_Filter.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                obj.poles = obj.w(1).*Chebyshev_Filter.CalcPolesLPHP(obj.Amax, obj.order);
            elseif ((type == "Band") || (type == "Notch"))
                obj.w = EnforceSym(obj.w, obj.type);
                obj.CF = Chebyshev_Filter.CalcCF(obj.w);
                obj.order = Chebyshev_Filter.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                obj.poles = Chebyshev_Filter.CalcPolesLPHP(obj.Amax, obj.order);
                obj.poles = obj.CF.* Chebyshev_Filter.Map(obj.poles, obj.w, obj.CF);
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
            n = (acosh(sqrt(nMin/nMax)))/(acosh(ratio));
            order = ceil(n);
        end
        
        function poles = CalcPolesLPHP(Amax,order)
            %CalcPolesLPHP Method calc's poles for LP/HP
            % Theta
            if (mod(order,2) == 0)
                counter  = order /2;
                m = zeros(1,counter);
                for k  = 0:(counter-1)
                    m(k+1) = k;
                end
            else
                counter  = (order + 1) /2;
                m = zeros(1,counter);
                for k  = 0:(counter-1)
                    m(k+1) = k;
                end
            end
            theta = (pi/2) - (((2*m + 1)*pi) / (2*order));
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
            %Poles
            poles = (-a*cos(theta) + 1j*b*sin(theta)) ;
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
                w = [0 0 0 0];
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

