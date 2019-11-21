%% 4.9
clc
Amax = 1;
Amin = 30;
w = [1000,3000];
type = "Low";
f1  = Butterworth(Amax,Amin,w,type);
f1.w0
f1.Q
%% 4.20
clc
Amax = 0.5;
Amin = 30;
w = [5,1.5]*2*pi*1000;
type = "High";
f2  = Butterworth(Amax,Amin,w,type);
f2.w0
f2.Q
%% 5.7
clc
Amax = 1;
Amin = 30;
w = [5,15]*1000;
type = "Low";
f3  = Chebyshev(Amax,Amin,w,type);
f3.w0
f3.Q
%% 5.10
clc
Amax = 1;
Amin = 20;
w = [1000,250];
type = "High";
f4  = Chebyshev(Amax,Amin,w,type);
f4.w0
f4.Q
%% 6.9
clc
Amax = 2;
Amin = 30;
w = [15,20,7.5,40] *2*pi*1000;
type = "Band";
f5 = Butterworth(Amax,Amin,w,type);
f5.w0
f5.Q
%% 
clc
Amax = 2;
Amin = 30;
w = [7.5,40,15,20] *2*pi*1000;
type = "Notch";
f6 = Butterworth(Amax, Amin, w, type);
f6.w0
f6.Q
%%
clc
Amax = 2;
Amin = 30;
w = [15,20,7.5,40] *2*pi*1000;
type = "Band";
f7 = Chebyshev(Amax,Amin,w,type);
f7.w0
f7.Q
%% 6.13
clc
Amax = 1;
Amin = 18;
w = [1,20,2.5,8] *2*pi*1000;
type = "Notch";
f8 = Chebyshev(Amax,Amin,w,type);
f8.w0
f8.Q
%% 
clc