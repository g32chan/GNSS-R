clc;

SNR=-2.76;          % SNR [dB]
theta=13.24;        % Incident angle [deg]
A=90.31;            % Area [dB-m^2]
R=-285.25;          % Distance [dB-m]
EIRP=27.38;         % Transmitted power [dB]
Gr=11.59;           % Receiver gain [dB]
S=-1.63;            % [dB]
sigma=9.81;         % [dB]
N=-142.2;           % Noise power [dBW]
Gpr=pow2db(1023);   % Processing gain[dB]
lambda=0.1904;      % Wavelength [m]
k=mag2db(1.5*(4*pi)^3/lambda^2);

sigma_hat=k-Gpr+N +SNR-EIRP-Gr -2*S-A-R;

% Ht=20200000;    % [m]
% Hr=680000;      % [m]
% Rt=Ht/cos(deg2rad(theta));  % [m]
% Rr=Hr/cos(deg2rad(theta));  % [m]
% R=mag2db(Rt*Rr);

k2=mag2db(2/3*lambda^2/(4*pi)^3);
SNR_hat=k2+EIRP-N+sigma+Gpr+Gr+R+2*S+A;

