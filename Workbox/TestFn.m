%% 4.9
clc
Amax = 1;
Amin = 30;
w = [1000,3000];
type = "Low";
f1  = Butterworth(Amax,Amin,w,type);
f1.Display
%% 4.20
clc
Amax = 0.5;
Amin = 30;
w = [5,1.5]*2*pi*1000;
type = "High";
f2  = Butterworth(Amax,Amin,w,type);
f2.Display
%% 5.7
clc
Amax = 1;
Amin = 30;
w = [5,15]*1000;
type = "Low";
f3  = Chebyshev(Amax,Amin,w,type);
f3.Display
%% 5.10
clc
Amax = 1;
Amin = 20;
w = [1000,250];
type = "High";
f4  = Chebyshev(Amax,Amin,w,type);
f4.Display
%% 6.9
clc
Amax = 2;
Amin = 30;
w = [15,20,7.5,40] *2*pi*1000;
type = "Band";
f5 = Butterworth(Amax,Amin,w,type);
f5.Display
%% 
clc
Amax = 2;
Amin = 30;
w = [7.5,40,15,20] *2*pi*1000;
type = "Notch";
f6 = Butterworth(Amax, Amin, w, type);
f6.Display
%%
clc
Amax = 2;
Amin = 30;
w = [15,20,7.5,40] *2*pi*1000;
type = "Band";
f7 = Chebyshev(Amax,Amin,w,type);
f7.Display
%% 6.13
clc
Amax = 1;
Amin = 18;
w = [1,20,2.5,8] *2*pi*1000;
type = "Notch";
f8 = Chebyshev(Amax,Amin,w,type);
f8.Display;
%% 10.1
clc
Classification = "Butterworth";
Type = "Low";
Amax = 3;
Amin = 25;
F = [0.1,0.2];
f9 = Digital(Classification, Type, Amax, Amin, F);
f9.Display;
%% 
clc
Classification = "Butterworth";
Type = "High";
Amax = 3;
Amin = 25;
F = [0.2,0.1];
f10 = Digital(Classification, Type, Amax, Amin, F);
f10.Display;
%% 
clc
Classification = "Chebyshev";
Type = "Low";
Amax = 3;
Amin = 25;
F = [0.1,0.2];
f11 = Digital(Classification, Type, Amax, Amin, F);
f11.Display;
%% 
clc
Classification = "Chebyshev";
Type = "High";
Amax = 3;
Amin = 25;
F = [0.2,0.1];
f12 = Digital(Classification, Type, Amax, Amin, F);
f12.Display;
%% 10.2
clc
Classification = "Chebyshev";
Type = "Band";
Amax = 0.5;
Amin = 20;
F = [0.2,0.3,0.15,0.35];
f13 = Digital(Classification, Type, Amax, Amin, F);
f13.Display;
%% 
clc
Classification = "Butterworth";
Type = "Band";
Amax = 0.5;
Amin = 20;
F = [0.2,0.3,0.15,0.35];
f14 = Digital(Classification, Type, Amax, Amin, F);
f14.Display;
%% 
clc
Classification = "Chebyshev";
Type = "Notch";
Amax = 2;
Amin = 16;
F = [0.1,0.25,0.15,0.2];
f15 = Digital(Classification, Type, Amax, Amin, F);
f15.Display;
%% 
clc
Classification = "Butterworth";
Type = "Notch";
Amax = 2;
Amin = 16;
F = [0.1,0.25,0.15,0.2];
f16 = Digital(Classification, Type, Amax, Amin, F);
