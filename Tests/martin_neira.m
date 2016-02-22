EIRP=25;        % Transmitter power [dBW]
R1=24e6;        % Distance [m]
R2=913e3;       % [m]
theta=36;       % [deg]
B=2e7;          % Bandwidth [Hz]
lambda=0.19;    % Wavelength [m]
F=2;            % Noise figure [dB]
Gr=37;          % Receiver gain [dB]
a=8.5*17;        % [km^2]
A=43*53;        % [km^2]
sigma=12;       % [dB]

rho=8500;      % [m]
v=7500;         % [m/s]
Tc=428e-6;      % [s]
N=428;

% Ts=290*(db2pow(F)-1);   % Effective temperature [K]
Gr=4*pi*R2^2/A/1e6/cos(deg2rad(theta));
Si=db2pow(EIRP)/4/pi/R1^2;
SNR=Si*lambda^2/8/pi/cos(deg2rad(theta))/1.38e-23/db2pow(F)/290/B*a/A*db2pow(sigma);
SNR=pow2db(SNR);

N=B*lambda*R2/4/v/rho;

