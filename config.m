%% Script configuration

%% Flags
clk = 1;    % Use clock file
nav = 1;    % Use navigation file
avg = 0;    % Use CNR averaging
fix = 1;    % Fix position
rep = 1;    % Run through all PRNs
plt = 0;    % Plot results

%% Gains
gain.Gd = 5;    % Piksi
gain.Gr = 3;    % Antcom
% gain.Gd = 4;    % GPS
% gain.Gr = 11.8; % UK-DMC

%% Flights
% day = '270616';
% time = '144300';
% rhcp = '1';
% lhcp = '0';
% elev = 337;
% gain.Gd = 3;
% target_lla = [43.47474 -80.53864 376]; % ECH
% % target_lla = [43.4720 -80.5450 300]; % SLC

% day = '101016';
% time = '205800';
% rhcp = '0';
% lhcp = '1';
% elev = 345;
% target_lla = [43.4751 -80.5507 359]; % CIF Top

% day = '101016';
% time = '212430';
% rhcp = '0';
% lhcp = '1';
% elev = 300;
% target_lla = [43.4740 -80.5533 315]; % CIF/Lake

% day = '101016';
% time = '213300';
% rhcp = '0';
% lhcp = '1';
% elev = 300;
% target_lla = [43.4740 -80.5533 315]; % CIF/Lake

% day = '111016';
% time = '140810';
% rhcp = '0';
% lhcp = '1';
% elev = 300;
% target_lla = [43.4740 -80.5533 315]; % CIF/Lake

% day = '111016';
% time = '143700';
% rhcp = '0';
% lhcp = '1';
% elev = 300;
% target_lla = [43.47411 -80.55660 300]; % Reserve/Lake

% day = '121016';
% time = '182700';
% rhcp = '0';
% lhcp = '1';
% elev = 333;
% target_lla = [43.4740 -80.5532 347]; % CIF/Lake

day = '121016';
time = '183030';
rhcp = '0';
lhcp = '1';
elev = 333;
target_lla = [43.4740 -80.5532 350]; % CIF/Lake

% day = '251016';
% time = '180550';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5532 348]; % CIF/Lake

% day = '261016';
% time = '180920';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5532 346]; % CIF/Lake

% day = '261016';
% time = '181230';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5533 351]; % CIF/Lake

% day = '261016';
% time = '182025';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5533 352]; % CIF/Lake

% day = '261016';
% time = '182300';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5534 357]; % CIF/Lake

% day = '261016';
% time = '182545';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5534 360]; % CIF/Lake

% day = '141116';
% time = '194700';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5533 358]; % CIF/Lake

% day = '141116';
% time = '200000';
% rhcp = '1';
% lhcp = '0';
% elev = 333;
% target_lla = [43.4740 -80.5533 364]; % CIF/Lake

% day = '151116';
% time = '171200';
% rhcp = '1';
% lhcp = '0';
% elev = 334;
% target_lla = [43.4741 -80.5567 351]; % Reserve/Lake

% day = '151116';
% time = '171500';
% rhcp = '1';
% lhcp = '0';
% elev = 334;
% target_lla = [43.4740 -80.5567 359]; % Reserve/Lake

% day = '151116';
% time = '171800';
% rhcp = '1';
% lhcp = '0';
% elev = 334;
% target_lla = [43.4740 -80.5568 359]; % Reserve/Lake

% day = '151116';
% time = '172800';
% rhcp = '1';
% lhcp = '0';
% elev = 334;
% target_lla = [43.4741 -80.5567 358]; % Reserve/Lake

% day = '151116';
% time = '173100';
% rhcp = '1';
% lhcp = '0';
% elev = 334;
% target_lla = [43.4741 -80.5567 365]; % Reserve/Lake


%% Filenames
clkFile = [day '_' time '_ttyUSB' rhcp '_clock.csv'];
navFile = [day '_' time '_ttyUSB' rhcp '_nav.csv'];
dirFile = [day '_' time '_ttyUSB' rhcp '_results.csv'];
refFile = [day '_' time '_ttyUSB' lhcp '_results.csv'];
kmlFile = ['KML\' day '_' time '.kml'];
clear day time rhcp lhcp

