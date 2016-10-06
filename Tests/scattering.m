clear; close all; clc

R = [-4069896.7033860330 -3583236.9637350840 4527639.2717581640];
T = [-11178791.991294 -13160191.204988 20341528.127540];
ref=-50:1:50;
dir=48;
[S, theta, sigma]=scatterCoeff(R,T,dir,ref);
% plot(ref,sigma)
plot(ref,pow2db(sigma))
xlabel('Reflected CN_{0} [dB-Hz]')
ylabel('\sigma^{0} [dB]')
% ylabel('\sigma_{b} [dB-m^2]')
