function hofsresponse(n,d, firstdecade, lastdecade)
close all
w=logspace(firstdecade,lastdecade ,1000); % generate 1000 points equally spaced on a logarithmic axis
% from 0.1 to 1000
b=n; %numerator
a=d; %denominator
h=freqs(b,a,w); %evaluate frequency response at those frequencies in the w vector
mag=20*log10(abs(h));
phase=angle(h)*180/pi;
subplot(2,1,1);
semilogx(w,mag);
xlabel('Frequency in radians/sec');
ylabel('Gain in dB');grid;
subplot(2,1,2);
semilogx(w,phase);
xlabel('Frequency in radians/sec');
ylabel('Phase in Degrees');grid;
end