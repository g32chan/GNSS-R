%% Main Data Processing Script
% Dependencies:
%   7-zip: Decompresses downloaded files
%   Python: Generate KML file
clear; close all; clc
addpath('include')
addpath('Tests')
addpath('EKF')
addpath('EMwave')
% addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\SiRF')
addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Quadcopter Experiment\gps_exp_data\height_25m')

%% Import Data
piksi = 0;

if piksi
    dirFile = 'C:\Users\gary\Google Drive\WatSat\Competition 2014-2016\Technical Design\Payload (1)\Sample_Data\20160229_sample_data.csv';
    dirData = piksiParse(dirFile);
    refFile = '';
    refData = piksiParse(refFile);
else
    dirFile = '270616_144300_ttyUSB1_results.csv';
    dirData = sirfParse(dirFile);
    clkFile = '270616_144300_ttyUSB1_clock.csv';
    clkData = clkParse(clkFile);
    navFile = '270616_144300_ttyUSB1_nav.csv';
    navData = navParse(navFile);
    refFile = '270616_144300_ttyUSB0_results.csv';
    refData = sirfParse(refFile);
end

% Retrieve IGS information
igsFile = igsDownload(dirData.wn, dirData.tow);
igsData = igsRead(igsFile);

%% Calculate Positions
[R, T, DOP] = getPositions(dirData, igsData, clkData);

% Separate data
Txyz = T.data(:, T.header.X:T.header.Z);
Rxyz = R.data(:, R.header.X:R.header.Z);
time = R.data(:, R.header.time);
% Rxyz = navData.data(:, navData.header.X:navData.header.Z);
% time = navData.data(:, navData.header.ToW);
skip = any(DOP > 10, 2);

% Plot location
R_lla = ecef2lla(Rxyz);
% R_lla(skip, :) = [];
% time(skip, :) = [];
% for i = 1:length(skip)
%     if skip(i) == 1
%         R_lla(i, :) = [];
%         time(i, :) = [];
%     end
% end
% target_lla = [43.4720 -80.5450 0];
target_lla = [43.4747 -80.5388 370];
plotLLA(time, R_lla, target_lla)
mean_lla = mean(R_lla, 1);
r = dist3(lla2ecef(mean_lla), lla2ecef(target_lla));
fprintf('Distance between expected and calculated location is %f m\n', r)

% Setup specular data array
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

% Calculate specular data
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
%     Rtemp = xyz(idx, :);
%     Rtemp = lla2ecef(target_lla);
    dir = dirData.data(i, dirData.header.CNR);
    idx = find(refData.data(:, refData.header.GPSTime) == t & refData.data(:, refData.header.Satellite) == prn);
    if isempty(idx)
        continue
    end
    ref = refData.data(idx, refData.header.CNR);
    [Stemp, theta, sigma0, area] = scatterCoeff(Rtemp, Ttemp, dir, ref);
    S.data(i, S.header.X) = Stemp(1);
    S.data(i, S.header.Y) = Stemp(2);
    S.data(i, S.header.Z) = Stemp(3);
    S.data(i, S.header.theta) = theta;
    S.data(i, S.header.brcs) = sigma0;
    S.data(i, S.header.area) = area;
end
S.data(any(S.data == 0, 2), :) = [];
fprintf('Done\n')
% [S, theta, sigma0] = scatterCoeff(Rxyz, Txyz, dir, ref);

%% Infer Reflection Surface
% h = 0.1;    % RMS height [m]
% L = 3.0;	% Correlation length [m]
% % mss = 0.002;
% mss = 2*(h/L)^2;
% q = zeros(size(S.data, 1), 3);
% Rcs = zeros(size(S.data, 1), 1);
% e = zeros(size(S.data, 1), 1);
% fprintf('Calculating surface properties...')
% for i = 1:size(S.data, 1)
%     t = S.data(i, S.header.time);
%     idx = find(R.data(:, R.header.time) == t);
%     Ttemp = T.data(i, T.header.X:T.header.Z);
%     Stemp = S.data(i, S.header.X:S.header.Z);
%     Rtemp = R.data(idx, R.header.X:R.header.Z);
%     theta = S.data(i, S.header.theta);
%     sigma0 = S.data(i, S.header.brcs);
%     q(i, :) = qvec(Rtemp, Ttemp, Stemp);
%     Rcs(i) = invKAGO(sigma0, q(i, :), mss);
%     if abs(Rcs(i)) > 1
%         error('Reflection coefficient is out of bounds');
%     end
%     e(i) = invFresnel(Rcs(i), theta);
% end
% fprintf('Done\n')
% % q = qvec(R, T, S);
% % Rcs = invKAGO(sigma0, q, mss);
% % e = invFresnel(Rcs, theta);

%% Add to map
% res = 1;    % Cells per degree
% latlim = [45 90];
% lonlim = [-180 180];
% rows = res*diff(latlim);
% cols = res*diff(lonlim);
% map = zeros(rows, cols);

plotBRCS(S, R, target_lla)
plotPRNcluster(S, R, target_lla)

generateKML('out.kml', S)

