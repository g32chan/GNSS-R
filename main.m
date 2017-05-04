%% Main Data Processing Script
% Dependencies:
%   7-zip: Decompresses downloaded files
%   Python: Generate KML file
clear; close all; clc
addpath('include')
addpath('Tests')
addpath('EKF')
addpath('EMwave')
addpath('IGS')
addpath('Daaxa')
addpath('KML')
% addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\SiRF')
addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Quadcopter Experiment\gps_exp_data\height_25m')
addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Quadcopter Experiment\Data')

%% Configure settings
config % Read from config.m

%% Import Data
fprintf('Starting processing script...\n')

dirData = sirfParse(dirFile, avg);  % Import direct file
refData = sirfParse(refFile, avg);  % Import reflected file

% Interpolate missing data
time = dirData.data(1, dirData.header.GPSTime):dirData.data(end, dirData.header.GPSTime);
dirData = interpFix(dirData, time);
refData = interpFix(refData, time);

if clk
    clkData = clkParse(clkFile, time);    % Import clock file
end
if nav
    navData = navParse(navFile, time);    % Import navigation file
end

% Retrieve IGS information
igsFile = igsDownload(dirData.wn, dirData.tow);
igsData = igsRead(igsFile);

clear dirFile clkFile navFile refFile igsFile

%% Calculate Positions
if clk
    [R, T, DOP] = getPositions(dirData, igsData, clkData);
else
    [R, T, DOP] = getPositions(dirData, igsData);
end

% Separate data
if nav
    temp = navData.data(:, navData.header.X:navData.header.Z);
    R.data(:, R.header.X:R.header.Z) = egmCorrect(temp);
    R.data(:, R.header.time) = navData.data(:, navData.header.ToW);
end
if fix
    Rxyz = median(R.data(:, R.header.X:R.header.Z), 1);
    R.data(:, R.header.X:R.header.Z) = repmat(Rxyz, length(R.data(:, R.header.X:R.header.Z)), 1);
end
Txyz = T.data(:, T.header.X:T.header.Z);
Rxyz = R.data(:, R.header.X:R.header.Z);
time = R.data(:, R.header.time);
skip = any(DOP > 10, 2);

% Calculate distance
R_lla = ecef2lla(Rxyz);
% if ~nav
%     R_lla(skip, :) = [];
%     time(skip, :) = [];
% end

if plt && ~fix
    plotLLA(time, R_lla, target_lla)
end

mean_lla = median(R_lla, 1);
r = dist3(lla2ecef(mean_lla), lla2ecef(target_lla));
fprintf('Distance between expected and calculated location is %f m\n', r)

%% Select PRNs
prns = intersect(dirData.PRN, refData.PRN);
fprintf('Satellites found: %s\n', sprintf('%i ', prns))
if ~rep
    prn = input('Select satellite to analyze: ');
    if ~any(prn == prns)
        error('Not an option')
    end
    prns = prn;
end
for i = 1:length(prns)
    prn = prns(i);
    
%% Calculate specular data
    fprintf('Starting PRN %i\n', prn)
    S = scatterCoeff(R, T, dirData, refData, prn, elev, gain);
    S.data(any(S.data == 0, 2), :) = [];
    S.data(any(S.data == -90, 2), :) = [];
    brcs = pow2db(S.data(:, S.header.brcs));
    area = pow2db(S.data(:, S.header.area));
    Sxyz = S.data(:, S.header.X:S.header.Z);
    S_lla = ecef2lla(Sxyz);

%% Infer Reflection Surface
%     h = 1; % RMS height [m]
%     L = 3.0; % Correlation length [m]
%     mss = 2*(h/L)^2;
    mss = 0.05;
    fprintf('Calculating surface properties...')
    q = qvec(R, T, S);
    Rcs = invKAGO(S, q, mss);
    eps = invFresnel(Rcs, S);
    fprintf('Done\n')

%% Plot
    if plt
        plotSNR(dirData, refData, prn)
        plotBRCS(S, R, target_lla)
%         plotPRNcluster(S, R, target_lla)
        plotDielectric(brcs, Rcs, eps)
    end

    generateKML(kmlFile, S)
end

fprintf('Script finished\n')

