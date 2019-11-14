classdef Butterworth < Filter
    %BUTTERWORTH_FILTER
    %   Used in Linear Circuit Filter Design
    
    methods
        
        function obj = Butterworth(Amax, Amin, w, type)
            %BUTTERWORTH_FILTER Construct an instance of this class
            %   This constructer will find all values corrisponding with
            %   filter design.
            obj = obj@Filter(Amax, Amin, w, type);
            
            if ((type == "Low") || (type == "High"))
                
                obj.order = Butterworth.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                
                obj.w0 = Butterworth.Calcw0(obj.Amax, obj.w, obj.order, obj.type);
                
                obj.poles = Butterworth.CalcPolesLPHP(obj.order, obj.w0);
                
            elseif ((type == "Band") || (type == "Notch"))
                
                obj.w = Filter.EnforceSym(obj.w, obj.type);
                
                obj.CF = Filter.CalcCF(obj.w);
                
                obj.order = Butterworth.CalcOrder(obj.Amax, obj.Amin, obj.w, obj.type);
                
                obj.w0 = Butterworth.Calcw0(obj.Amax, obj.w, obj.order, obj.type);
                                
                obj.poles = Butterworth.CalcPolesLPHP(obj.order,obj.w0);
                
                obj.poles = obj.CF.*Filter.Map(obj.poles, obj.w, obj.CF);
                
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
            elseif (type == "Band")
                w0 = 1./((10^(Amax/10) -1)^(1/(2*n)));
            elseif (type == "Notch")
                w0 = 1*((10^(Amax/10) -1)^(1/(2*n)));
            else
                w0 = 0;
            end
        end
        
        function poles = CalcPolesLPHP(order,w0)
            %CalcPolesLPHP Method calc's poles for LP/HP
            %   Assuming w0 = 1
            n = order;
            k = 0:(2*n - 1);
            if (mod(n,2) == 0)
                s = w0*exp (1j *(2*k+1)*pi  /(2*n));
            elseif (mod(n,2) == 1)
                s = w0*exp (1j *pi * k /n);
            else
                s = 0;
            end
            poles = s(real(s) <0);
        end
        
    end
end

