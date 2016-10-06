function [S, theta, sigma, area] = scatterCoeff(R, T, dir, ref)
% R: Transmitter position in WGS84
% T: Receiver position in WGS84
% dir: SNR of direct signal
% ref: SNR of reflected signal
% S: Specular point in WGS84
% theta: Incident angle [deg]
% sigma: Scattering coefficient

% Load common parameters
c = 299792458;
f = 1.57542e9;
lambda = c/f;

% Get specular point
[S, theta] = specularPoint(R, T);

% Calculate distances
Rd = dist3(R, T);
Rr = dist3(R, S);
Rt = dist3(T, S);
R_lla = ecef2lla(R);

% Calculate reflection area
[~, ~, area] = gpsFootprint(lambda, R_lla(3)-337, deg2rad(90-theta));

% Calculate sigma
sigma = db2pow(ref)./db2pow(dir).*(Rt/Rd)^2.*(4*pi*Rr^2)./area;
% sigma = db2pow(ref-dir).*4.*pi.*Rr^2;

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

