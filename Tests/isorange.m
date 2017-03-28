clear; close all; clc

c = 299792458;      % speed of light [m/s]
CArate = 1023000;   % C/A code rate [Hz]

H = 680e3;          % receiver altitude [m]
theta = 40;         % incidence angle [deg]
% tau = 1;            % delay [chip]

figure; hold on
for tau = 1:50
    delta = 1/CArate*c*tau;
    eps = 90-theta;

    b = sqrt(2*H*delta/sind(eps));
    a = b/sind(eps);

%     A = pi*a*b;

    t = linspace(0,2*pi);
    x = a*cos(t)/1e3;
    y = b*sin(t)/1e3;

    plot(x,y,'g');
end
xlim([-100,100])
ylim([-100,100])
