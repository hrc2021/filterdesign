classdef Butter_Filter
    %BUTTERFILTER Given arguements this class with develope corispondidng
    %values for w0, Q and poles for a Butterworth filters. Currently give
    % arguements in the form of  (Amax, Amin, wp, ws, "low" or "high")
    properties
        w0
        Q
        Amax
        wp
        Amin
        ws
        type
        ratio
        order
        poles
    end
    methods
        function obj = Butter_Filter(varargin)
            if nargin == 5
                obj.Amax = varargin{1};
                obj.Amin = varargin{2};
                obj.wp = varargin{3};
                obj.ws = varargin{4};
                obj.type  = varargin{5};
                obj.order = CalcOrder(obj);
                obj.Q = CalcQ(obj);
                obj.w0 = Calcw0(obj);
                obj.poles = CalcPoles(obj);
            else
                disp("Error!")
            end
            
        end
        function DispSpec(obj)
            disp(['Order= ' num2str(obj.order)])
            disp(['w0= ' num2str(obj.w0)])
            for k=1:length(obj.Q)
                disp(['Q= ' num2str(obj.Q(k))]);
            end
        end
        function order =  CalcOrder(obj)
            if (obj.type == "low")
                obj.ratio = obj.ws/obj.wp;
            elseif  (obj.type == "high")
                obj.ratio = obj.wp/obj.ws;
            end
            nMin = 10^(obj.Amin/10) -1;
            nMax = 10^(obj.Amax/10) -1;
            n = (log(nMin/nMax))/(2*log(obj.ratio));
            order = ceil(n);
        end
        function Q = CalcQ(obj)
            n = obj.order;
            k = 0:(2*n - 1);
            if (mod(n,2) == 0)
                s = exp (1j *(2*k+1)*pi  /(2*n));
            else
                s = exp (1j *pi * k /n);
            end
            s = s(real(s)<0);
            a = pi -  angle(s);
            Q = unique(round((1./(2*cos(a))),4));
        end
        function w0 = Calcw0(obj)
            n = obj.order;
            if (obj.type == "low")
                w0 = obj.wp/((10^(obj.Amax/10) -1)^(1/(2*n)));
            elseif (obj.type == "high")
                w0 = obj.wp*((10^(obj.Amax/10) -1)^(1/(2*n)));
            end
        end
        function poles = CalcPoles(obj)
            n = obj.order;
            k = 0:(2*n - 1);
            if (round(mod(n,2),3) == 0)
                s = obj.w0* exp (1j *(2*k+1)*pi  /(2*n));
            else
                s = obj.w0 * exp (1j *pi * k /n);
            end
            poles = round(s(real(s) <0),5);
        end
    end
end
