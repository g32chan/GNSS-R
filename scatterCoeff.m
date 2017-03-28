function [S, theta, sigma, area] = scatterCoeff(R, T, dir, ref, e)
% R: Transmitter position in WGS84
% T: Receiver position in WGS84
% dir: SNR of direct signal
% ref: SNR of reflected signal
% e: Elevation above sea level [m]
% S: Specular point in WGS84
% theta: Incident angle [deg]
% sigma: Scattering coefficient
% area: Reflection footprint [m^2]

% Get specular point
[S, theta] = specularPoint(R, T, e);

% Calculate distances
Rd = dist3(R, T);
Rr = dist3(R, S);
Rt = dist3(T, S);
R_lla = ecef2lla(R);

% Calculate reflection area
area = gpsFootprint(R_lla(3)-e, 90-theta, 1);

% Calculate sigma
sigma = db2pow(ref)./db2pow(dir).*(Rt/Rd)^2.*(4*pi*Rr^2)./area;

% sigma = db2pow(ref-dir).*4.*pi.*Rr^2;
% if sigma <= 0
%     error('Sigma less than zero')
% end

% % Calculate noise power and density
% EIRP = 500;
% B = 2e6;
% 
% N = noisepow(B,3,290);
% N0 = N/B;
% 
% % Calculate direct SNR/CN0
% Pdir = friis(EIRP, lambda, Rd);
% dir = Pdir/N0;
% 
% % Calculate power
% Pinc = friis(EIRP, lambda, Rt);
% Pr = db2pow(ref).*N0;
% sigma = Pr./Pinc.*(4*pi*Rr^2)./area;

end

