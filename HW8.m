%% StartUP
startup
%% Question 1
w1 = [3,4,1.5,8] *2*pi*1000;
p1 = Butterworth(1,25,w1,"Band");
p1.Graph;
p1f = BandPass(p1.poles,"Case 1", 10e-9,10e3);
p1f.DisplaySpec;
%% Question 2
w2 = [2,5,2.5,4] *2*pi*1000;
p2 = Chebyshev(0.5,25,w2,"Notch");
p2.Graph;
%% Question 3
w3 = [15,40,20,30]*2*pi*1000;
p3 = Butterworth(2,25,w3,"Notch");
p3.Graph