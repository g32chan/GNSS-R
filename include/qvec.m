function q = qvec(R, T, S)
% R: receiver location in ECEF
% T: transmitter location in ECEF
% S: specular point location in ECEF
% q: scattering vector

c = 299792458;
f = 1.57542e9;
lambda = c/f;

RS_unit = (R-S)./norm(R-S);
TS_unit = (T-S)./norm(T-S);

q = 2*pi/lambda*(TS_unit+RS_unit);

end

