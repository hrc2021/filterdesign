 classdef Chebyshev_Filter
    properties
        w0
        Q
        Amax
        wp
        Amin
        ws
        E
        type
        order
        theta
        poles
        a
        b
    end
    methods
        function obj = Chebyshev_Filter(varargin) %(Amax, Amin, wp, ws, type)
            if nargin == 5
                obj.Amax = varargin{1};
                obj.Amin = varargin{2};
                obj.wp = varargin{3};
                obj.ws = varargin{4};
                obj.type  = varargin{5};
                obj.E = CalcE(obj);
                obj.order = CalcOrder(obj);
                obj.theta = CalcTheta(obj);
                obj.a = CalcA(obj);
                obj.b = CalcB(obj);
                obj.poles = CalcPoles(obj);
                obj.w0 = Calcw0(obj);
                obj.Q = CalcQ(obj);
            else
                disp("Error!")
            end
            
        end
        function E = CalcE(obj)
            E = sqrt((10^(obj.Amax/10))-1);
        end
        function order =  CalcOrder(obj)
            if (obj.type == "low")
                ratio = obj.ws/obj.wp;
            elseif  (obj.type == "high")
                ratio = obj.wp/obj.ws;
            end
            nMin = 10^(obj.Amin/10) -1;
            nMax = 10^(obj.Amax/10) -1;
            n = (acosh(sqrt(nMin/nMax)))/(acosh(ratio));
            order = ceil(n);
        end
        function theta = CalcTheta(obj)
            if (mod(obj.order,2) == 0)
                counter  = obj.order /2;
                m = zeros(1,counter);
                for k  = 0:(counter-1)
                    m(k+1) = k;
                end
            else
                counter  = (obj.order + 1) /2;
                m = zeros(1,counter);
                for k  = 0:(counter-1)
                    m(k+1) = k;
                end
            end
            theta = (pi/2) - (((2*m + 1)*pi) / (2*obj.order));
        end
        function a = CalcA(obj)
            Ei = 1/obj.E;
            Ei2 = Ei^2;
            Oi = 1/obj.order;
            t1 = (Ei + sqrt(Ei2+1))^Oi;
            t2 = (Ei + sqrt(Ei2+1))^(-1*Oi);
            a = (1/2)*( t1 - t2);
        end
        function b = CalcB(obj)
            Ei = 1/obj.E;
            Ei2 = Ei^2;
            Oi = 1/obj.order;
            t1 = (Ei + sqrt(Ei2+1))^Oi;
            t2 = (Ei + sqrt(Ei2+1))^(-1*Oi);
            b = (1/2)*( t1 + t2);
        end
        function poles = CalcPoles(obj)
            s = obj.wp*(-obj.a*cos(obj.theta) + 1j*obj.b*sin(obj.theta));
            poles = s;
        end
        function w0 = Calcw0(obj)
            w0 = abs(obj.poles);
        end
        function Q = CalcQ(obj)
            Q = 1 ./ ( 2 .* abs( cos (angle(obj.poles))));
            Q = round(Q,4);
        end
    end
end