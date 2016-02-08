function [a, b, area] = gpsFootprint(lambda, h, e)
% lambda: wavelength [m]
% h: height of receiver [m]
% e: elevation angle [rad]
% a: semi-major axis [m]
% b: semi-minor axis [m]
% area: area of footprint [m^2]

b = sqrt(lambda*h./sin(e)+(lambda/2./sin(e)).^2);
a = b./sin(e);
area = pi.*a.*b;
end

