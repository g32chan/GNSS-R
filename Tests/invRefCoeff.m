clear; close all; clc

figure; hold on;
for theta=[0,15,30,60]
    e=1:100;
    [Rvv,Rhh]=fresnelCoeff(e,deg2rad(theta));
    [Rco,Rcs]=cocross(Rvv,Rhh);
    plot(e,Rcs)
end
legend('\theta=0','\theta=15','\theta=30','\theta=60','location','best')
xlabel('Dielectric constant, \epsilon')
ylabel('Reflection coefficient, |\Re|')
