function theta = snell(R, T, S)
% T: Transmitter position in WGS84
% R: Receiver position in WGS84
% S: Specular point in WGS84
% theta: Incident angle [deg]

tol = 0.1;	% Tolerance [deg]

RS_unit = (R-S)./norm(R-S);
TS_unit = (T-S)./norm(T-S);
S_unit = S./norm(S);

thetaR = rad2deg(acos(dot(RS_unit, S_unit)));
thetaT = rad2deg(acos(dot(TS_unit, S_unit)));

if (abs(thetaR-thetaT) < tol) 
    theta = mean([thetaR thetaT]);	% Return average
else
    warning('Specular point does not satisfy Snell''s law');
    theta = -90;
end

end

