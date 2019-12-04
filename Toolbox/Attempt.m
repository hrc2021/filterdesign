clear
clc
Hzcoef(1,:,1) = [1,2,1];
Hzcoef(2,:,1) = [1,-0.9827,0.66648];
Hzcoef(1,:,2) = [1,1,0];
Hzcoef(2,:,2) = [1, -0.59771,0];

% Hz | z = e^(j*w*T) = e^(j*2*pi*f*T) = e^(j*2*pi*(f/fs))
fdivfs = 0:0.01:0.5;
z = exp(1j*2*pi*(fdivfs));

Hzint = ones(length(Hzcoef(1,1,:)), length(z));
for n = 1:length(Hzcoef(1,1,:))
Hznum = Hzcoef(1,1,n) + Hzcoef(1,2,n).*(z.^-1) +Hzcoef(1,3,n).*(z.^-2);
Hzden = Hzcoef(2,1,n) + Hzcoef(2,2,n).*(z.^-1) +Hzcoef(2,3,n).*(z.^-2);
Hzint(n,:) = Hznum./Hzden;
end

Hz = ones(1,length(Hzint(1,:)));
for n = 1:length(Hzint(1,:))
    for i = 1:length(Hzint(:,1))
        Hz(n) = Hz(n)*(Hzint(i,n));
    end
end
close all
clf

plot(fdivfs,20*log10(abs(Hz)));grid