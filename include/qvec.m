function q = qvec(R, T, S)
% R: receiver location in ECEF
% T: transmitter location in ECEF
% S: specular point location in ECEF
% q: scattering vector

c = 299792458;
f = 1.57542e9;

q = zeros(size(S.data, 1), 3);

for i = 1:size(S.data, 1)
    t = S.data(i, S.header.time);
    idx = R.data(:, R.header.time) == t;
    Rtemp = R.data(idx, R.header.X:R.header.Z);
    Ttemp = T.data(i, T.header.X:T.header.Z);
    Stemp = S.data(i, S.header.X:S.header.Z);
    
    % convert to local coordinates
    Rl = ecef2enu(Rtemp, Stemp);
    Tl = ecef2enu(Ttemp, Stemp);
    Sl = ecef2enu(Stemp, Stemp);

    RS_unit = (Rl-Sl)./norm(Rl-Sl);
    TS_unit = (Tl-Sl)./norm(Tl-Sl);

    q(i,:) = 2*pi*f/c*(TS_unit+RS_unit);
end

end

