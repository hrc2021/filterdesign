function DLCF =  HWSolver(Classification,Type,DCGain,Amax,Amin,PassBand,StopBand,SamplingFreq)
%Filter Creation
fs = SamplingFreq;
fpass = PassBand;
fstop = StopBand;
F = [fpass,fstop]./fs;
DLCF = Digital(Classification,Type,Amax,Amin,F);

%Display Coefficients
DLCF.Display

DigitalPloter(DLCF.coef,DCGain)
end

