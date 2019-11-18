function[R1, R2] = RVoltageDiv(Gain,R)

R1 = R/Gain;
R2 = (R*R1) / (R +R1);

end

