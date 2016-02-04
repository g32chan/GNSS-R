f = 1.57542e9;                              % Frequency
c = 3e8;                                    % Speed of light
l = c/f;                                    % Wavelength
E = 5:1:90;                                 % Elevation angle (deg)
e = deg2rad(E);                             % Elevation angle (rad)
[a1, b1, A1] = gpsFootprint(l, 5, e);
[a2, b2, A2] = gpsFootprint(l, 30, e);

% Plot 
figure(1);
semilogx(A1, E, A2, E);
grid on;
title('Scattering Area vs. Elevation Angle');
legend('h = 5m', 'h = 30m');
ylabel('Elevation Angle [deg]');
xlabel('Area [m^2]');
