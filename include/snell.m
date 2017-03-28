function theta = snell(R, T, S)
% T: Transmitter position in WGS84
% R: Receiver position in WGS84
% S: Specular point in WGS84
% theta: Incident angle [deg]

tol = 5;	% Tolerance [deg]

RS_unit = (R-S)./norm(R-S);
TS_unit = (T-S)./norm(T-S);
S_unit = S./norm(S);

thetaR = acosd(dot(RS_unit, S_unit));
thetaT = acosd(dot(TS_unit, S_unit));

if (abs(thetaR-thetaT) < tol) 
    theta = mean([thetaR thetaT]);	% Return average
else
    warning('Specular point does not satisfy Snell''s law');
    R_lla = ecef2lla(R);
    T_lla = ecef2lla(T);
    S_lla = ecef2lla(S);
    theta = -90;
end

end

