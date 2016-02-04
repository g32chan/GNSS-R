function [a, b, A] = gpsFootprint(l, h, e)
b = sqrt(l*h./sin(e)+(l/2./sin(e)).^2);
a = b./sin(e);
A = pi.*a.*b;
