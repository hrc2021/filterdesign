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
        
        function Graph(obj)
            
            Hs = ones(1000,length(obj.w0));
            mag = ones(1000,length(obj.w0));
            phase = ones(1000,length(obj.w0));
            phasedeg = ones(1000,length(obj.w0));
            totalresp = ones(1000,1);
            fcf = log10(obj.CF);
            fd = fcf  - 1;
            ld = fcf + 1;
            s = logspace(fd,ld,1000);
            for n = 1:length(obj.w0)
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

