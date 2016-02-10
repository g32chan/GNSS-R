clear; close all; clc

theta=0:1:90;
Vb=30;
er=3.12+0.009*Vb;
ei=0.04+0.005*Vb;
e=er-1i*ei;
c=3e8;
f=1575.42e6;
lambda=c/f;
alpha=2*pi/lambda*imag(sqrt(e));
d=1/2/alpha;
thetab = rad2deg(atan(sqrt(e)));
cs=cos(deg2rad(theta));
sn=sin(deg2rad(theta));
Rvv=(e.*cs-sqrt(e-sn.^2))./(e.*cs+sqrt(e-sn.^2));
Rhh=(cs-sqrt(e-sn.^2))./(cs+sqrt(e-sn.^2));
Rco=(Rvv+Rhh)/2;
Rcs=(Rvv-Rhh)/2;
figure; hold
plot(theta,real(-Rco))
plot(theta,real(Rcs))
plot(real(thetab)*ones(91),linspace(0,1,91),'k')
xlabel('Incident angle [deg]')
ylabel('Reflection')
title(['Fresnel Components for V_{b} = 30' char(8240)])
legend('Co-polarization', 'Cross-polarization', 'Brewster Angle')

