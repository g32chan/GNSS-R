clear; close all; clc

parameters;
theta=0:1:90;
Vb=30;
er=3.12+0.009*Vb;
ei=0.04+0.005*Vb;
e=er+1i*ei;
alpha=k*imag(sqrt(e));
d=1/2/alpha;
brewster = rad2deg(atan(sqrt(e)));
[Rvv,Rhh]=fresnelCoeff(e,deg2rad(theta));
[Rco,Rcs]=cocross(Rvv,Rhh);
figure; hold
plot(theta,real(-Rco))
plot(theta,real(Rcs))
plot(real(brewster)*ones(91),linspace(0,1,91),'k')
xlabel('Incident angle [deg]')
ylabel('Reflection')
title(['Fresnel Components for V_{b} = 30' char(8240)])
legend('Co-polarization', 'Cross-polarization', 'Brewster Angle')

