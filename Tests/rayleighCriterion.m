clear; close all; clc
c=299792458;
f=1575.42e6;
lambda=c/f;
theta=0:1:90;
figure
for phase=[pi/8 pi/4 pi/2 pi]
    h=lambda/4/pi*phase./cos(deg2rad(theta)).*100;
    semilogy(theta,h)
    hold on
end
grid on
legend('\Delta\phi = \pi/8', '\Delta\phi = \pi/4', '\Delta\phi = \pi/2', '\Delta\phi = \pi', 'Location', 'best')
xlabel('Incidence Angle [deg]')
ylabel('Height Variation [cm]')
ylim([0.1,100])
title('Rayleigh Criterion for GPS L1')
