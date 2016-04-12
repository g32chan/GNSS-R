%% Main Data Processing Script
% Dependencies:
%   7-zip: Decompresses downloaded IGS files
clear; close all; clc
format compact
format long
addpath('include')
addpath('Tests')
addpath('EKF')
addpath('EMwave')
addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\SiRF')

%% Import Data
piksi = 1;

if piksi
    dir = 'C:\Users\gary\Google Drive\WatSat\Competition 2014-2016\Technical Design\Payload (1)\Sample_Data\20160229_sample_data.csv';
    dirData = piksiParse(dir);
    target_lla = [43.4727 -80.5402 0];
else
    dir = 'results_040915_181251_mid28.dat.csv';
    dirData = sirfParse(dir);
    target_lla = [43.4720 -80.5450 0];
end

% ref = '.csv';
% refData = importData(ref);

% Retrieve IGS information
igs = igsDownload(dirData.wn, dirData.tow);
igsData = igsRead(igs);

%% Calculate Positions
[R, T] = getPositions(dirData, igsData);

lla = ecef2lla(R.data(:,2:4));

figure
plot(lla(:,2),lla(:,1),target_lla(2),target_lla(1),'o')

% [S, theta, sigma] = scatterCoeff(R, T, dir, ref);

%% Infer Reflection Surface


%% Add to map
res = 1;    % Cells per degree
latlim = [45 90];
lonlim = [-180 180];
rows = res*diff(latlim);
cols = res*diff(lonlim);
map = zeros(rows, cols);

