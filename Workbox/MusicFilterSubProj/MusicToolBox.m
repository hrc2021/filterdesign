classdef MusicToolBox
    %MUSICTOOLBOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filenamein
        pathnamein
        filenameout
        y
        fs
    end
    
    methods
        function obj = MusicToolBox()
            [obj.filenamein, obj.pathnamein] = uigetfile('*.wav', 'Pick a "bad" .wav file to filter ...  ');
            obj.filenameout= [obj.filenamein(1:end-7)  'filtered.wav'];
            [obj.y, obj.fs]=audioread([obj.pathnamein obj.filenamein]);
        end
        
        function Analysis(obj)
            % Power Spectral Density
            figure(1)
            [Pxx,F] = pwelch(obj.y,hann(22050),0,22050,1);
            plot(F, 10*log10(abs(Pxx)))
            title(['PSD of file: ', obj.filenamein])
            xlabel('Fraction of Sampling Frequency')
            ylabel('Power Spectrum Magnitude (dB)')
            grid on
            MusicToolBox.Wait()
            
            %Freqz Plot
            figure(2)
            [H,w]=freqz(obj.y(1:4096),1,4096);
            plot(w/(2*pi), 20*log10(abs(H)));
            title(['FREQZ of file: ', obj.filenamein])
            xlabel('Fraction of Sampling Frequency')
            ylabel('Magnitude (dB)')
            grid on
            MusicToolBox.Wait()
            
            
            %Spectrogram
            figure(3)
            specgram(obj.y,2048,1)
            title(['SPECGRAM of file: ', obj.filenamein])
            ylabel('Fraction of Sampling Frequency')
            xlabel('Time (samples)')
            grid on
            colorbar
            MusicToolBox.Wait()
        end
        
        function Filtering(obj,Classification,Type,Amax,Amin,F)
            %Filter Creation
            df = Digital(Classification, Type, Amax, Amin, F);
            num = df.coef(1,:,1);
            den = df.coef(2,:,1);
            if not(length(df.coef(1,1,:)) == 1)
                for n = 2:length(df.coef(1,1,:))
                    num = conv(num,df.coef(1,:,n));
                    den = conv(den,df.coef(2,:,n));
                end
            end
            k = 1/(max(abs(freqz(num, den, 1024))));
            num=num*k;
            
            %Plot Filter
            figure(4)
            [H,w]=freqz(num,den,4096);
            plot(w/2/pi,20*log10(abs(H)))
            title('Magnitude Response of Filter')
            ylabel('Magnitude Response (dB)')
            xlabel('Fraction of Sampling Frequency')
            axis([0 0.5 -50 10]);
            grid on
            
            
            % Plot pole/zero plot
            figure(5)
            zplane(num,den)
            title('Pole/Zero Plot')
            
            
            %Implement Filter
            newy=filter(num, den, obj.y);
            
            %Save Filtered Data
            audiowrite(obj.filenameout, newy, obj.fs);
            
            % look at filtered file in frequency domain
            figure(6)
            [Pnewy,F] = pwelch(newy,hann(22050),0,22050,1);
            plot(F, 10*log10(abs(Pnewy)))
            title(['PSD of file: ', obj.filenameout])
            xlabel('Fraction of Sampling Frequency');
            ylabel('Power Spectrum Magnitude (dB)')
            axis([0 0.5 -50 10]);
            grid on
            
            %  Look at both filtered and unfiltered file on same plot frequency domain
            figure(7)
            [pyy, ~] = pwelch(obj.y,hann(22050),0,22050,1);
            [pyynew, fq] = pwelch(newy,hann(22050),0,22050,1);
            magy=10*log10(abs(pyy));
            magynew=10*log10(abs(pyynew));
            plot(fq,magy,fq,magynew);
            title(['PSD of files: ', obj.filenamein , ' and ' obj.filenameout])
            xlabel('Fraction of Sampling Frequency');
            ylabel('Power Spectrum Magnitude (dB)')
            axis([0 0.5 -50 10]);
            grid on
            legend('Original Music', 'Filtered Music')
            
            % Send filtered data to sound card
            disp('Press Enter to Continue and to Play Filtered Music')
            pause
            numsecs=10;
            sound(newy(1:numsecs*obj.fs),22050);
            
            % group delay plot
            figure(10)
            [gd,wd]=grpdelay(num,den,512);
            plot(wd/2/pi, gd)
            title('Group Delay of Filter')
            xlabel('Fraction of Sampling Frequency');
            ylabel('Group Delay in Samples');
            grid on
        end
    end
    methods(Static)
        function Wait()
            disp('Press enter to continue')
            pause
        end
    end
end

