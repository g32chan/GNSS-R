function plotLLA(time, lla, target)
% time: time vector
% lla: lat/lon/alt vector
% target: target location

figure(1)
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])

subplot(2,2,1)
plot(lla(:,2),lla(:,1),target(2),target(1),'o', 'MarkerFaceColor', 'red')
% x = [0.18 0.15];
% y = [0.65 0.62];
% annotation('textarrow', x, y, 'String', 'Expected receiver location', 'FontSize', 16)
title('Target')
xlabel('Longitude [deg]')
ylabel('Latitude [deg]')
set(gca, 'FontSize', 24)

subplot(2,2,2)
plot(time, lla(:,1))
title('Latitude')
xlabel('GPS Time [sec]')
ylabel('Degrees')
set(gca, 'FontSize', 24)
axis tight

subplot(2,2,3)
plot(time, lla(:,2))
title('Longitude')
xlabel('GPS Time [sec]')
ylabel('Degrees')
set(gca, 'FontSize', 24)
axis tight

subplot(2,2,4)
plot(time, lla(:,3))
title('Altitude')
xlabel('GPS Time [sec]')
ylabel({'Height Above';'WGS84 Ellipsoid [m]'})
set(gca, 'FontSize', 24)
axis tight

end

