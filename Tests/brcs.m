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

% SNR=-2.76;          % SNR [dB]
% theta=13.24;        % Incident angle [deg]
% A=90.31;            % Area [dB-m^2]
% R=-285.25;          % Distance [dB-m]
% EIRP=27.38;         % Transmitted power [dB]
% Gr=11.59;           % Receiver gain [dB]
% S=-1.63;            % [dB]
% sigma=9.81;         % [dB]
N=-142.2;           % Noise power [dBW]
Gpr=pow2db(1023);   % Processing gain[dB]
lambda=0.1904;      % Wavelength [m]

Ht=20200000;    % [m]
Hr=680000;      % [m]

N=pow2db(noisepow(2e6,2.5,290));

k=pow2db(2/3/(4*pi)^3*lambda^2);

for s=1:18
    Rt=Ht/cos(deg2rad(theta(s)));  % [m]
    Rr=Hr/cos(deg2rad(theta(s)));  % [m]
    R=-pow2db(Rt^2*Rr^2);

    sigma_hat(s)=-k-Gpr+N+SNR(s)-EIRP(s)-Gr(s)-S(s)-A(s)-R;
%     sigma_hat(s)=-k-Gpr+N+SNR(s)-EIRP(s)-Gr(s)-S(s)-A(s)-R(s);
end

% SNR_hat=k+EIRP-N+sigma+Gpr+Gr+R+S+A;

figure
plot(time,sigma,time,sigma_hat)
xlabel('Second')
ylabel('\sigma^0 [dB]')
legend('Estimate from thesis','Calculated')
figure
plot(time,abs(sigma-sigma_hat))
xlabel('Second')
ylabel('Error [dB]')
