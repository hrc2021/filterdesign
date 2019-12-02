%% Old Transformation
n = 0:10;
w = n .* 2 .*pi;  %Divided by imaginary "T"
z = exp(1j .* w) %Times imaginary "T"
%% Bilinear Transformation 
% A one to one mapping
w = 0:10;
s  = 1j* w;
z = (2+s)./(2-s)
%% Notes
% Comes from z  = exp(1j .* 2.* atan (w1 / 2 ))
% Transforms into z = (2 + 1j*w1) ./ (2 - 1j*w1);
% So unwarp Equation:   w = 2*atan(w1./2)
% And warp  Equation:   w1 =  2 * tan(w./2)
% UnWarp NewFreq = (2*atan(OldFreq./2)) ./ (2* pi)
% Warp NewFreq = (2*tan((2* pi*OldFreq)./2))