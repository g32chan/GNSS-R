% clear; close all; clc
M = 20;
CN0 = 10:1:50;
x = db2pow(CN0)./1000;
mu = (x*M+1)./(x+1);
figure
plot(CN0,mu)
grid on
xlabel('C/N_0 [dB-Hz]')
ylabel('\mu')

