%% Setup
clear
clf
clc
close all
figure
scale = [-2,2,-2,2];
axis(scale)
hold on
mag = 200;
%% New Angle
ang = pi/4;
s = (0:0.1:mag) * exp(1j*(pi - ang));
Digital.MyBLT(s);
z = Digital.MyBLT(s);
plot(real(z),imag(z))
%% New Angle 
ang = pi/2;
s = (0:0.1:mag) * exp(1j*(pi - ang));
Digital.MyBLT(s);
z = Digital.MyBLT(s);
plot(real(z),imag(z))