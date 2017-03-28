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
piksi = 0;
clk = 0;
nav = 0;
plot = 0;

day = '270616';
time = '144300';
rhcp = '1';
lhcp = '0';
e = 337;
% day = '261016';
% time = '182025';
% rhcp = '1';
% lhcp = '0';
% e = 300;

% target_lla = [43.4720 -80.5450 300]; % SLC
target_lla = [43.47474 -80.53864 376]; % ECH
% target_lla = [43.47531 -80.55044 300]; % CIF Top
% target_lla = [43.4740 -80.5533 315]; % CIF/Lake
% target_lla = [43.47411 -80.55660 300]; % Reserve/Lake

%% Import Data
fprintf('Starting processing script...\n')
if piksi
    dirFile = 'C:\Users\gary\Google Drive\WatSat\Competition 2014-2016\Technical Design\Payload (1)\Sample_Data\20160229_sample_data.csv';
    dirData = piksiParse(dirFile);
    refFile = '';
    refData = piksiParse(refFile);
else
    dirFile = [day '_' time '_ttyUSB' rhcp '_results.csv'];
    dirData = sirfParse(dirFile);
    if clk
        clkFile = [day '_' time '_ttyUSB' rhcp '_clock.csv'];
        clkData = clkParse(clkFile);
    end
    if nav
        navFile = [day '_' time '_ttyUSB' rhcp '_nav.csv'];
        navData = navParse(navFile);
    end
    refFile = [day '_' time '_ttyUSB' lhcp '_results.csv'];
    refData = sirfParse(refFile);
end

% Retrieve IGS information
igsFile = igsDownload(dirData.wn, dirData.tow);
igsData = igsRead(igsFile);

kmlFile = ['KML\' day '_' time '.kml'];
clear day time dirFile clkFile navFile refFile

%% Calculate Positions
if clk
    [R, T, DOP] = getPositions(dirData, igsData, clkData);
else
    [R, T, DOP] = getPositions(dirData, igsData);
end

% Separate data
Txyz = T.data(:, T.header.X:T.header.Z);
Rxyz = R.data(:, R.header.X:R.header.Z);
time = R.data(:, R.header.time);
if nav
    Rxyz = navData.data(:, navData.header.X:navData.header.Z);
    time = navData.data(:, navData.header.ToW);
end
skip = any(DOP > 10, 2);

% Plot location
R_lla = ecef2lla(Rxyz);
if ~nav
    R_lla(skip, :) = [];
    time(skip, :) = [];
end

if plot
    plotLLA(time, R_lla, target_lla)
end
mean_lla = median(R_lla, 1);
r = dist3(lla2ecef(mean_lla), lla2ecef(target_lla));
fprintf('Distance between expected and calculated location is %f m\n', r)

%% Calculate specular data
S.header.time = 1;
S.header.prn = 2;
S.header.X = 3;
S.header.Y = 4;
S.header.Z = 5;
S.header.theta = 6;
S.header.brcs = 7;
S.header.area = 8;
S.data = zeros(size(T.data, 1), length(fieldnames(S.header)));
S.data(:, 1) = T.data(:, T.header.time);
S.data(:, 2) = T.data(:, T.header.prn);

fprintf('Calculating specular data...')
time = R.data(:, R.header.time);
for i = 1:size(S.data, 1)
    Ttemp = Txyz(i, :);
    t = T.data(i, T.header.time);
    prn = T.data(i, T.header.prn);
    idx = time == t;
    if skip(idx)
        continue
    end
    Rtemp = Rxyz(idx, :);
%     Rtemp = lla2ecef(mean_lla);
%     Rtemp = xyz(idx, :);
%     Rtemp = lla2ecef(target_lla);
    dir = dirData.data(i, dirData.header.CNR);
    idx = find(refData.data(:, refData.header.GPSTime) == t & refData.data(:, refData.header.Satellite) == prn);
    if isempty(idx)
        continue
    end
    ref = refData.data(idx, refData.header.CNR);
    [Stemp, theta, sigma0, area] = scatterCoeff(Rtemp, Ttemp, dir, ref, e);
    S.data(i, S.header.X:S.header.Z) = Stemp;
    S.data(i, S.header.theta) = theta;
    S.data(i, S.header.brcs) = sigma0;
    S.data(i, S.header.area) = area;
end
S.data(any(S.data == 0, 2), :) = [];
% S.data(any(S.data == -90, 2), :) = [];
brcs = pow2db(S.data(:, S.header.brcs));
area = pow2db(S.data(:, S.header.area));
Sxyz = S.data(:, S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);
fprintf('Done\n')
% [S, theta, sigma0] = scatterCoeff(Rxyz, Txyz, dir, ref);

%% Infer Reflection Surface
h = 1; % RMS height [m]
L = 3.0; % Correlation length [m]
% mss = 0.002;
mss = 2*(h/L)^2;
fprintf('Calculating surface properties...')
q = qvec(R, T, S);
Rcs = invKAGO(S, q, mss);
e = invFresnel(Rcs, S);
fprintf('Done\n')

%% Add to map
if plot
    plotBRCS(S, R, target_lla)
    plotPRNcluster(S, R, target_lla)
end

generateKML(kmlFile, S)

fprintf('Script finished\n')

