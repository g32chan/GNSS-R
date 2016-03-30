% Common parameters
%       Phased out. Use for reference only

%% Constants
c = 299792458;              % Speed of light [m/s]
omega = 7.2921151467e-5;	% Earth rotation rate [rad/s]
% mu = 3.986005e14;           % Earth gravitational parameter [s/m^(1/2)]
% pi = 3.1415926535898;       % GPS pi

%% GPS parameters
fc = 1575.42e6;             % Carrier frequency [Hz]
wc = 2*pi*fc;               % Carrier frequency [rad]
lambda = c/fc;              % Carrier wavelength [m]
k = wc/c;                   % Wavenumber [rad/m]
EIRP = 500;                 % Transmitted power [W]
B = 2e6;                    % Bandwidth [Hz]

%% WGS84 parameters
WGS84_a = 6378137;                      % Semimajor axis [m]
WGS84_f = 1/298.257223563;              % Flattening
WGS84_b = WGS84_a*(1-WGS84_f);          % Semiminor axis [m]
WGS84_e = sqrt(2*WGS84_f-WGS84_f^2);    % Eccentricity

%% Receiver parameters
F = 3;                  % Antenna noise figure [dB]
Gr = 3.7;               % Antenna gain [dB]
Glna = 33;              % LNA gain [dB]
T0 = 290;               % Reference temperature [K]
