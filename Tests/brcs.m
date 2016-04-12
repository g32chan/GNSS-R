clear; close all; clc;

[~,~,raw]=xlsread('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\Table 6-4 (Gleason).xlsx','Sheet1','A2:I19');
data=reshape([raw{:}],size(raw));
clearvars raw;

time=data(:,1);
SNR=data(:,2);
theta=data(:,3);
A=data(:,4);
R=data(:,5);
EIRP=data(:,6);
Gr=data(:,7);
S=data(:,8);
sigma=data(:,9);
sigma_hat=zeros(size(sigma));

N=-142.2;
Gpr=10*log10(1023);
lambda=299792458/1.57542e9;
k=10*log10(((3/2)*(4*pi)^3)/(lambda^2));

Ht=20200000;
Hr=680000;

% N=10*log10(1.38e-23*290*(10^(2.5/10)-1)*1e3);

for t=1:18
    sigma_hat(t)=k-Gpr+N+SNR(t)-EIRP(t)-Gr(t)-abs(S(t))-A(t)+abs(R(t));
    
%     Rt=Ht/cos(deg2rad(theta(t)));
%     Rr=Hr/cos(deg2rad(theta(t)));
%     R=-10*log10(Rt^2*Rr^2);
% 
%     sigma_hat(t)=k-Gpr+N+SNR(t)-EIRP(t)-Gr(t)-abs(S(t))-A(t)+abs(R);
end

figure
plot(time,sigma,time,sigma_hat)
xlabel('Second')
ylabel('\sigma^0 [dB]')
legend('Estimate from thesis','Calculated','location','best')

figure
plot(time,abs(sigma-sigma_hat))
xlabel('Second')
ylabel('Error [dB]')
