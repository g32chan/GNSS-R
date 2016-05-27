function enu = ecef2enu(P, ref)
% P: point in ECEF
% ref: reference point in ECEF
% enu: P transformed to ENU

lla = ecef2lla(ref);
Rx = rotx(90-lla(1))';
Rz = rotz(90+lla(2))';

delta = (P-ref)';

enu = (Rx*Rz*delta)';

end

