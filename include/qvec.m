function q = qvec(R, T, S)
% R: receiver location in ECEF
% T: transmitter location in ECEF
% S: specular point location in ECEF
% q: scattering vector

% convert to local coordinates
Rl = ecef2enu(R, S);
Tl = ecef2enu(T, S);
Sl = ecef2enu(S, S);

c = 299792458;
f = 1.57542e9;

RS_unit = (Rl-Sl)./norm(Rl-Sl);
TS_unit = (Tl-Sl)./norm(Tl-Sl);

q = 2*pi*f/c*(TS_unit+RS_unit);

end

