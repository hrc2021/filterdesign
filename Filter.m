classdef (Abstract) Filter 
    %FILTER Summary of this class goes here
    %   Detailed explanation goes here
    
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
        
        function obj = Filter(Amax, Amin, w, type)
            %FILTER Construct an instance of this class
            %   Detailed explanation goes here
            obj.Amin = Amin;
            obj.Amax = Amax;
            obj.w = w;
            obj.type = type;
        end
        
    end
    
    methods(Static)
        
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
                elseif w(2) > w(3)*w(4)/w(1)
                    w(2) = w(3)*w(4)/w(1);
                end
            end
            if abs((sqrt(w(1)*w(2)) - sqrt(w(3)*w(4)))) > 01.e-13
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
            s1 = (b.*poles./2) + sqrt((((b.*poles).^2)./4) - 1);
            s2 = (b.*poles./2) - sqrt((((b.*poles).^2)./4) - 1);
            s = [s1 s2];
            poles = s(real(s) < 0);
        end
        
    end
end

