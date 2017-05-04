function S = scatterCoeff(R, T, dir, ref, prn, e, gain)
% R: Receiver positions in WGS84
% T: Transmitter positions in WGS84
% dir: SNR/CN0 of direct signal [dB]/[dB-Hz]
% ref: SNR/CN0 of reflected signal [dB]/[dB-Hz]
% prn: Satellite PRN
% e: Elevation above sea level [m]
% S: Specular point in WGS84
% theta: Incident angle [deg]
% sigma: Scattering coefficient
% area: Reflection footprint [m^2]

%% Initialize
S.header.time = 1;
S.header.prn = 2;
S.header.X = 3;
S.header.Y = 4;
S.header.Z = 5;
S.header.theta = 6;
S.header.brcs = 7;
S.header.area = 8;
S.data = zeros(size(R.data, 1), length(fieldnames(S.header)));
S.data(:, 1) = R.data(:, R.header.time);
S.data(:, 2) = repmat(prn, size(R.data, 1), 1);

%% Calculate specular data
fprintf('Calculating specular data...')
time = R.data(:,R.header.time);
for t = 1:length(time)
    % Receiver location
    idx = find(R.data(:, R.header.time) == time(t));
    if isempty(idx)
        continue
    end
    Rxyz = R.data(idx, R.header.X:R.header.Z);
    
    % Transmitter location
    idx = find(T.data(:, T.header.time) == time(t) & T.data(:, T.header.prn) == prn);
    if isempty(idx)
        continue
    end
    Txyz = T.data(idx, T.header.X:T.header.Z);
    
    % Get specular point
    Sxyz = specularPoint(Rxyz, Txyz, e);
    S.data(t, S.header.X:S.header.Z) = Sxyz;

    % Calculate incident angle and test Snell's law
    theta = snell(Rxyz, Txyz, Sxyz);
    S.data(t, S.header.theta) = theta;

    % Calculate distances
    Rd = dist3(Rxyz, Txyz);
    Rr = dist3(Rxyz, Sxyz);
    Rt = dist3(Txyz, Sxyz);
    R_lla = ecef2lla(Rxyz);

    % Calculate reflection area
    area = gpsFootprint(R_lla(3)-e, 90-theta, 'isorange');
    % area = gpsFootprint(R_lla(3)-e, 90-theta, 'fresnel');
    S.data(t, S.header.area) = area;

    % Calculate sigma
    idx = find(dir.data(:, dir.header.GPSTime) == time(t) & dir.data(:,dir.header.Satellite) == prn);
    dirCNR = dir.data(idx, dir.header.CNR);
    if isempty(idx)
        continue
    end
    idx = find(ref.data(:, ref.header.GPSTime) == time(t) & ref.data(:,ref.header.Satellite) == prn);
    refCNR = ref.data(idx, ref.header.CNR);
    if isempty(idx)
        continue
    end
%     sigma = db2pow(refCNR)./db2pow(dirCNR).*(Rt/Rd)^2.*(4*pi*Rr^2)./area;
    sigma = db2pow(refCNR)./db2pow(dirCNR).*(Rt/Rd)^2.*(4*pi*Rr^2)./area.*db2pow(gain.Gd)./db2pow(gain.Gr);
    S.data(t, S.header.brcs) = sigma;
end

fprintf('Done\n')

%%
% % % Antenna gains
% % Gr = 11.8; % UK-DMC
% % Gd = 4; % GPS
% % Gr = 3; % Antcom
% % Gd = 5; % Piksi
% 
% % Get specular point
% S = specularPoint(R, T, e);
% 
% % Calculate incident angle and test Snell's law
% theta = snell(R, T, S);
% 
% % Calculate distances
% Rd = dist3(R, T);
% Rr = dist3(R, S);
% Rt = dist3(T, S);
% R_lla = ecef2lla(R);
% 
% % Calculate reflection area
% area = gpsFootprint(R_lla(3)-e, 90-theta, 'isorange');
% % area = gpsFootprint(R_lla(3)-e, 90-theta, 'fresnel');
% 
% % Calculate sigma
% sigma = db2pow(ref)./db2pow(dir).*(Rt/Rd)^2.*(4*pi*Rr^2)./area;
% % sigma = db2pow(ref)./db2pow(dir).*(Rt/Rd)^2.*(4*pi*Rr^2)./area.*db2pow(Gd)./db2pow(Gr);

%%
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

