% Common parameters

% Constants
c = 299792458;          % Speed of light [m/s]

% GPS parameters
fc = 1575.42e6;         % Carrier frequency [Hz]
lambda = c/fc;          % Carrier wavelength [m]
EIRP = 500;             % Transmitted power [W]
B = 2e6;                % Bandwidth [Hz]

% WGS84 parameters
WGS84_a = 6378137;                      % Semimajor axis [m]
WGS84_f = 1/298.257223563;              % Flattening
WGS84_b = WGS84_a*(1-WGS84_f);          % Semiminor axis [m]
WGS84_e = sqrt(2*WGS84_f-WGS84_f^2);    % Eccentricity

% Receiver parameters
F = 3;                  % Antenna noise figure [dB]
Gr = 3.7;               % Antenna gain [dB]
Glna = 33;              % LNA gain [dB]
