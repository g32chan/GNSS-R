clear; close all; clc

c = 299792458;      % Speed of light [m/s]
f = 1575.42e6;      % Carrier frequency [Hz]
lambda = c/f;       % Carrier wavelength [m]
EIRP = 500;         % Transmitted power [W]
B = 2e6;            % Bandwidth [Hz]
F = 3;              % Antenna noise figure [dB]
Gr = 3.7;           % Antenna gain [dB]
Glna = 33;          % LNA gain [dB]
T0 = 290;           % Reference temperature [K]

R=20200000;             % GPS orbit [m]
R2=700000;              % Receiver orbit [m]
theta=deg2rad(0:1:89);  % Incident angle [rad]

Gr=db2pow(Gr);      % Receiver gain []
% Glna=db2pow(Glna);  % LNA gain []
Pr=EIRP.*Gr.*(lambda./4./pi./R.*cos(theta)).^2;   % Received power [W]
Pr=pow2db(Pr);      % Received power [dBW], typical -160 dBW

N=pow2db(noisepow(B,F,T0));     % Noise power [dBW]
N0=N-pow2db(B);     % Noise density [dBW/Hz]

SNR=Pr-N;           % Signal-to-noise ratio [dB]
CN0=Pr-N0;          % Carrier-to-noise-density ratio [dB-Hz]

figure;
plot(rad2deg(theta),CN0)
xlabel('Incident angle [deg]')
ylabel('Carrier to noise density [dB-Hz]')
title('Ground Receiver CN_0')
