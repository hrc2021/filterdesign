classdef Chebyshev < Filter
    %Chebyshev_FILTER
    %   Used in Linear Circuit Filter Design
    properties
        a
        b
    end
    methods
        
        function obj = Chebyshev(Amax, Amin, w, type)
            %Chebyshev_Filter Construct an instance of this class
            %   This constructer will find all values corrisponding with
            %   filter design.
            obj = obj@Filter(Amax, Amin, w, type);
            
            if ((type == "Low") || (type == "High"))
                
                obj.order = Chebyshev.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                
                [obj.poles,obj.a,obj.b] = Chebyshev.CalcPolesLPHP(obj.Amax, obj.order);
                
                if type == "High"
                    obj.poles = 1./obj.poles;
                end
                
                obj.poles = obj.w(1) * obj.poles;
                
                obj.poles = obj.poles(imag(obj.poles) > -1.0e-13);
                
                obj.w0 = abs(obj.poles);
                
                obj.Q = 1 ./ ( 2.* abs(cos(angle(obj.poles))));
                
            elseif ((type == "Band") || (type == "Notch"))
                
                obj.w = Filter.EnforceSym(obj.w, obj.type);
                
                obj.CF = Filter.CalcCF(obj.w);
                
                obj.order = Chebyshev.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                
                [obj.poles,~,~] = Chebyshev.CalcPolesLPHP(obj.Amax, obj.order);
                
                if type == "Notch"
                    obj.poles = 1./ obj.poles;
                end
                
                obj.poles = obj.CF.* Filter.Map(obj.poles, obj.w, obj.CF);
                
                obj.poles = obj.poles(imag(obj.poles) > -1.0e-13);
                
                
                obj.w0 = abs(obj.poles);
                
                obj.Q = 1 ./ ( 2.* abs(cos(angle(obj.poles))));
                
            end
            
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
                ratio = (w(2) - w(1))  / (w(4) - w(3));
            end
            nMin = 10^(Amin/10) -1;
            nMax = 10^(Amax/10) -1;
            n = (acosh(sqrt(nMin/nMax))) / (acosh(ratio));
            order = ceil(n);
        end
        
        function [poles, a, b] = CalcPolesLPHP(Amax,order)
            %CalcPolesLPHP Method calc's poles for LP/HP
            % Theta
            if (mod(order,2) == 1)
                k  = 0: (2*order -1);
                that = exp(1j*pi*k /order);
            else
                k = 0:(2*order -1);
                that = exp((1j.* (2.*k +1) .* pi )./ (2*order));
            end
            that = that(real(that) < 0);
            theta = pi - angle(that);
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
            poles = (-a.*cos(theta) + 1j.*b.*sin(theta)) ;
        end
    end
end

