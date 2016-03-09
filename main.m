%% Main Data Processing Script
% Dependencies:
%   7-zip: Decompresses downloaded IGS files
clear; close all; clc

%% Import Data
dir = 'C:\Users\gary\Google Drive\WatSat\Competition 2014-2016\Technical Design\Payload (1)\Sample_Data\20160229_sample_data.csv';
dir = 'C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\SiRF\results_040915_181251_mid28.dat.csv';
ref = '.csv';
dirData = importData(dir);
refData = importData(ref);

%% Retrieve IGS Data
igs = igsDownload(wn, tow);
igsData = read_sp3(igs);

%% Verify Data


%% Calculate Sigma
sigma=scatterCoeff(R,T,dir,ref);

%% Infer Reflection Surface


%% Add to map
h = worldmap([45 90], [-180 180]);
geoshow('landareas.shp')

