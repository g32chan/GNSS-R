clear; close all; clc

flag = 2;

if flag == 1
    EIRP=28;        % Transmitter power [dBW]
    B=2e6;          % Bandwidth [Hz]
    a=27e3*54e3;    % Pulse footprint[m^2]
    rho=27e3;       % Pulse footprint semi-minor axis [m]
elseif flag == 2
    EIRP=25;        % Transmitter power [dBW]
    B=2e7;          % Bandwidth [Hz]
    a=8500*17e3;    % Pulse footprint[m^2]
    rho=8500;       % Pulse footprint semi-minor axis [m]
end

R1=24e6;        % Transmitter distance [m]
theta=36;       % Incidence angle [deg]
lambda=0.19;    % Wavelength [m]
F=2;            % Noise figure [dB]
% Gr=37;          % Receiver gain [dB]
A=43e3*53e3;    % Antenna footprint [m^2]
sigma=12;       % Bistatic radar cross section [dB]
R2=913e3;       % Receiver distance [m]
v=7500;         % Receiver velocity [m/s]

Tc = lambda*R2/2/v/rho;
N = floor(B*Tc/2);
% Ts=290*(db2pow(F)-1);   % Effective temperature [K]

Gr=pow2db((4*pi*R2^2)/(A*cosd(theta)));
Si=db2pow(EIRP)/(4*pi*R1^2);
SNR=Si/(4*pi*cosd(theta))/(2*1.38e-23*290*B/lambda^2)*(a/A)*db2pow(sigma)/db2pow(F);
SNR_N = SNR*N;

SNR = pow2db(SNR);
SNR_N = pow2db(SNR_N);


