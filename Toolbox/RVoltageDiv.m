function[R1, R2] = RVoltageDiv(Gain,R)

R1 = R/Gain;
R2 = (-1*R) / (Gain -1);

end

