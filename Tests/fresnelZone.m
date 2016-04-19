clear; close all; clc

f = 1.57542e9;      % Frequency
c = 299792458;      % Speed of light
lambda = c/f;       % Wavelength
E = 1:1:90;	        % Elevation angle (deg)
e = deg2rad(E);     % Elevation angle (rad)
[~, ~, A1] = gpsFootprint(lambda, 5, e);
[~, ~, A2] = gpsFootprint(lambda, 30, e);
[a, b, A3] = gpsFootprint(lambda, 700e3, e);

% Plot 
figure;
semilogy(E, A1, E, A2, E, A3);
grid on;
title('Scattering Area vs. Elevation Angle');
legend('h = 5m', 'h = 30m', 'h = 700km');
xlabel('Elevation Angle, \gamma [deg]');
ylabel('Area [m^2]');
