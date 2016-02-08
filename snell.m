function [ theta ] = snell( R,T,S )
% T: Transmitter position in WGS84
% R: Receiver position in WGS84
% S: Specular point in WGS84
% theta: Incident angle [deg]

RS_unit=(R-S)./norm(R-S);
TS_unit=(T-S)./norm(T-S);
S_unit=S./norm(S);
thetaR=rad2deg(acos(dot(RS_unit,S_unit)));
thetaT=rad2deg(acos(dot(TS_unit,S_unit)));
if (abs(thetaR-thetaT) < 0.001) % Difference < 1/1000th of degree
    theta=mean([thetaR thetaT]);
else
    error('Specular point does not satisfy Snell''s law');
end

end

