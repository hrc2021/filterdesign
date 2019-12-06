function HWSolver(Classification,Type,DCGain,Amax,Amin,PassBand,StopBand,SamplingFreq)
%Filter Creation
fs = SamplingFreq;
fpass = PassBand;
fstop = StopBand;
F = [fpass,fstop]./fs;
DesiredGain = dB2DC(DCGain);
DLCF = Digital(Classification,Type,Amax,Amin,F);

%Display Coefficients
DLCF.Display

%Build num and den of H(z)
num = DLCF.coef(1,:,1);
den = DLCF.coef(2,:,1);
if not(length(DLCF.coef(1,1,:)) == 1)
    for n = 2:length(DLCF.coef(1,1,:))
        num = conv(num,DLCF.coef(1,:,n));
        den = conv(den,DLCF.coef(2,:,n));
    end
end

%Calcluates Correct Gain
gain = (max(abs(freqz(num, den, 1024))));
k = DesiredGain/gain;
disp(['K value: ' num2str(k)])
num=num*k;

%Plot Response
figure
[H,w]=freqz(num,den,4096);
plot(w/2/pi,20*log10(abs(H)))
title('Magnitude Response of Filter')
ylabel('Magnitude Response (dB)')
xlabel('Fraction of Sampling Frequency')
axis([0 0.5 -50 45]);
grid on
end

