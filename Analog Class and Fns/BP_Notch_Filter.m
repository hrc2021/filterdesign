classdef BP_Notch_Filter
    properties
        CF
        type % "BP" or "Notch"
        class %Butter or Cheby
        bmath
        poles
        delta_wp
        delta_ws
        w % wp1 wp2 ws1 ws2
        base_filter
        Amin
        Amax
    end
    methods
        function obj = BP_Notch_Filter(Amax, Amin, wp1, wp2, ws1, ws2, type, class)
            obj.Amin = Amin;
            obj.Amax = Amax;
            obj.type = type;
            obj.class = class;
            obj.w = [wp1 wp2 ws1 ws2];
            obj.w = enforceSym(obj);
            obj.CF  = calcCF(obj);
            obj.delta_wp = calcDelta_wp(obj);
            obj.delta_ws =  calcDelta_ws(obj);
            obj.bmath = calcB(obj);
            obj.base_filter = calcBaseFilter(obj, obj.Amin, obj.Amax, obj.delta_wp, obj.delta_ws, obj.type, obj.class);
            obj.poles = obj.CF * map(obj);
        end
        function w = enforceSym(obj)
            w = obj.w;
            if obj.type == "BP"
                if w(4) >  w(1)*w(2)/w(3)
                    w(4) = w(1)*w(2)/w(3);
                elseif w(3) <  w(1)*w(2)/w(4)
                    w(3) = w(1)*w(2)/w(4);
                end
            elseif obj.type == "Notch"
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
        function CF = calcCF(obj)
            w = obj.w;
            CF1 = sqrt(w(1)*w(2));
            CF2 =  sqrt(w(1)*w(2));
            if not(CF1 == CF2)
                disp("Error! Center Frequency Failed");
                CF = -1;
            else
                CF  = CF1;
            end
        end
        function delta_wp = calcDelta_wp(obj)
            w = obj.w;
            delta_wp = w(2) - w(1);
        end
        function delta_ws = calcDelta_ws(obj)
            w = obj.w;
            delta_ws = w(4) - w(3);
        end
        function b = calcB(obj)
            delta_wp = obj.delta_wp;
            CF = obj.CF;
            b = delta_wp / CF;
        end
        function base_filter = calcBaseFilter(obj, Amin, Amax, delta_wp, delta_ws, type, class)
            wp = 1;
            if type == "BP"
                type = "low";
            elseif type == "Notch"
                type = "high";
            else
                disp("Error!")
            end
            if (type == "low")
                ratio = delta_ws/delta_wp;
            elseif  (type == "high")
                ratio = delta_wp/delta_ws;
            end
            nMin = 10^(Amin/10) -1;
            nMax = 10^(Amax/10) -1;
            if class == "Cheby"
                %Order
                n = (acosh(sqrt(nMin/nMax)))/(acosh(ratio));
                order = ceil(n);
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
                base_filter = (-a*cos(theta) + 1j*b*sin(theta)) ;
            elseif class == "Butter"
                %Order
                n = ceil((log(nMin/nMax))/(2*log(ratio)));
                %w0
                if (type == "low")
                    w0 = wp/((10^(Amax/10) -1)^(1/(2*n)));
                elseif (type == "high")
                    w0 = wp*((10^(Amax/10) -1)^(1/(2*n)));
                end
                %Poles
                k = 0:(2*n - 1);
                if (round(mod(n,2),3) == 0)
                    s = w0 * exp (1j *(2*k+1)*pi  /(2*n));
                else
                    s = w0 *exp (1j *pi * k /n);
                end
                base_filter = round(s(real(s) <0),5);
            else
                disp("Error! Bad Filter Class");
            end
        end
        function s = map(obj)
            bpoles = obj.bmath*obj.base_filter/2;
            s1 = bpoles + sqrt((bpoles.^2) -1);
            s2 = bpoles + sqrt((bpoles.^2) -1);
            s = [s1 s2];
            s = s(real(s) < 0);
        end
    end
end