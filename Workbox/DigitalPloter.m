function DigitalPloter(coef,Gain)
clf
close all

%Build Total Response
num = coef(1,:,1);
den = coef(2,:,1);

if not(length(coef(1,1,:)) == 1)
    for n = 2:length(coef(1,1,:))
        num = conv(num,coef(1,:,n));
        den = conv(den,coef(2,:,n));
    end
end

%Plot Pole/Zero
figure
zplane(num,den)
title('Pole/Zero Plot')

%Calcluates Correct Gain
DesiredGain = dB2DC(Gain);
gain = (max(abs(freqz(num, den, 1024))));
disp(['Orignal Gain: ' num2str(gain)])
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