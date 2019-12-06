%% Int Filter Music Obj
fm = MusicToolBox();
%% Run Analysis
fm.Analysis;
%% Filter .wav

Classification = "Chebyshev";
Type = "Notch";
Amax = 0.5;
Amin = 30;
%Type F while analysis
I = [0.17,0.19];
O = [0.165,0.195];
F = [O,I];


fm.Filtering(Classification,Type,Amax,Amin,F)
