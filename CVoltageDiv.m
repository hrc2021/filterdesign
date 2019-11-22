function[C1, C2] = CVoltageDiv(Gain,C)

C1 = Gain*C;
C2 = -1*(Gain - 1)*C;

end

