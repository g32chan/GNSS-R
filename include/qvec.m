function q = qvec(R, T, S)
% R: receiver location in ECEF
% T: transmitter location in ECEF
% S: specular point location in ECEF
% q: scattering vector

c = 299792458;
f = 1.57542e9;

q = zeros(size(R.data, 1), 3);

prn = S.data(1, S.header.prn);
time = R.data(:, R.header.time);
for t = 1:length(time)
    idx = R.data(:, R.header.time) == time(t);
    Rtemp = R.data(idx, R.header.X:R.header.Z);
    if isempty(Rtemp)
        continue
    end
    idx = T.data(:, T.header.time) == time(t) & T.data(:, T.header.prn) == prn;
    Ttemp = T.data(idx, T.header.X:T.header.Z);
    if isempty(Ttemp)
        continue
    end
    idx = S.data(:, S.header.time) == time(t);
    Stemp = S.data(idx, S.header.X:S.header.Z);
    if isempty(Stemp)
        continue
    end
    
    % convert to local coordinates
    Rl = ecef2enu(Rtemp, Stemp);
    Tl = ecef2enu(Ttemp, Stemp);
    Sl = ecef2enu(Stemp, Stemp);

    RS_unit = (Rl-Sl)./norm(Rl-Sl);
    TS_unit = (Tl-Sl)./norm(Tl-Sl);

    q(t,:) = 2*pi*f/c*(TS_unit+RS_unit);
end

q(any(q == 0, 2), :) = [];

end

