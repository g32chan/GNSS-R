clear; close all; clc

qx = 0;
qy = -0.17;
qz = 57.1;

R = .1:.1:.9;
mss = 1e-5:1e-5:5e-3;

q = [qx qy qz];
x = qx/qz;
y = qy/qz;

pdf = exp(-(x^2+y^2)./(2.*mss))./(2.*mss);
n = (norm(q./qz))^4;

for i = 1:length(R)
    sigma = pow2db(R(i)^2.*n.*pdf);
    plot(mss,sigma)
    hold on
end

xlabel('MSS')
ylabel('\sigma^0 [dB]')
