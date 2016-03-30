%% Main Data Processing Script
% Dependencies:
%   7-zip: Decompresses downloaded IGS files
clear; close all; clc
format compact
format long
addpath('Tests')
addpath('EKF')
addpath('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing')

%% Import Data
piksi = 1;

if piksi
    dir = 'C:\Users\gary\Google Drive\WatSat\Competition 2014-2016\Technical Design\Payload (1)\Sample_Data\20160229_sample_data.csv';
    [dirData, dirClk] = piksiParse(dir);
else
    dir = 'SiRF\results_040915_181251_mid28.dat.csv';
    clk = 'SiRF\clock_040915_181251_mid28.dat.csv';
    [dirData, dirClk] = sirfParse(dir, clk);
end

% ref = '.csv';
% refData = importData(ref);

% Retrieve IGS information
igs = igsDownload(dirData.wn, dirData.tow);
igsData = igsRead(igs);

%% Calculate Positions
[R, T] = getPositions(dirData, dirClk, igsData);

slc_lla = [43.472 -80.545 0];
slc = lla2ecef(slc_lla);
lla = ecef2lla(R.data(:,2:4));
if piksi
    lla = lla(abs(lla(:,1)-43.8)<0.05,:);
end

figure
plot(lla(:,2),lla(:,1),slc_lla(2),slc_lla(1),'o')

% [S, theta, sigma] = scatterCoeff(R, T, dir, ref);

%% Infer Reflection Surface


%% Add to map
res = 1;    % Cells per degree
latlim = [45 90];
lonlim = [-180 180];
rows = res*diff(latlim);
cols = res*diff(lonlim);
map = zeros(rows, cols);

