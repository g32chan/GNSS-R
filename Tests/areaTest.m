clear; close all; clc

c = 299792458;      % speed of light [m/s]
CArate = 1023000;   % C/A code rate [Hz]
f = 1.57542e9;      % L1 frequency [Hz]
lambda = c/f;       % L1 wavelength [m]
h = 680e3;          % receiver altitude [m]
theta = 40;         % incidence angle [deg]
tau = 1;            % delay [chip]

delta = 1/CArate*c*tau;
e = 90-theta;

% First Fresnel Zone
b1 = sqrt(lambda*h./sind(e) + (lambda/2./sind(e)).^2);
a1 = b1./sind(e);
area1 = pi.*a1.*b1;

% First Iso-Range Ellipse
b2 = sqrt(2*h*delta/sind(e));
a2 = b2/sind(e);
area2 = pi*a2*b2;
