clear; close all; clc

%% Configure
flag = 2;
if flag == 1
    prn = 13;
    elev = 0;
    n = 7;
    mss = 0.00003;
    navFile = 'Nav_RI.csv';
    dirFile = 'Ice Dir';
    refFile = 'Ice Ref';
    kmlFile = 'KML\DaaxaIce.kml';
elseif flag == 2
    prn = 22;
    elev = 0;
    n = 19;
    mss = 0.0075;
    navFile = 'Nav_RO.csv';
    dirFile = 'Ocean Dir';
    refFile = 'Ocean Ref';
    kmlFile = 'KML\DaaxaOcean.kml';
elseif flag == 3
    prn = 15;
    elev = 410;
    n = 19;
    mss = 0.0004;
    navFile = 'Nav_RL.csv';
    dirFile = 'Land PRN15 Dir';
    refFile = 'Land PRN15 Ref';
    kmlFile = 'KML\DaaxaLand15.kml';
elseif flag == 4
    prn = 18;
    elev = 340;
    n = 19;
    mss = 0.0006;
    navFile = 'Nav_RL.csv';
    dirFile = 'Land PRN18 Dir';
    refFile = 'Land PRN18 Ref';
    kmlFile = 'KML\DaaxaLand18.kml';
end    

%% Power
dirData = zeros(n,1);
refData = zeros(n,1);

for sec = 1:n
    dirTemp = load(['Daaxa\' dirFile '\DaaxaOut' sprintf('%2d', sec) '.dat']);
    refTemp = load(['Daaxa\' refFile '\DaaxaOut' sprintf('%2d', sec) '.dat']);
    dirTemp = dirTemp(:,6:end);
    refTemp = refTemp(:,6:end);
    
    dirData(sec) = calcSNR(dirTemp);
    refData(sec) = calcSNR(refTemp);
end

%% Receiver
navData = importData(navFile);
time = navData.data(:, navData.header.tow);
pos = navData.data(:, navData.header.X:navData.header.Z);
bias = navData.data(:, navData.header.bias);
wn = navData.data(1, navData.header.wn);
tow = time(1);

R.data = [time pos bias];
R.header.time = 1;
R.header.X = 2;
R.header.Y = 3;
R.header.Z = 4;
R.header.B = 5;

%% Transmitter
igsFile = igsDownload(wn, tow);
igsData = igsRead(igsFile);

satpos = zeros(3, length(time));
for i = 1:length(time)
    [satpos(:, i), ~] = getLocation(time(i), prn, igsData);
end
T.data = [time repmat(prn, length(time), 1) satpos'];
T.header.time = 1;
T.header.prn = 2;
T.header.X = 3;
T.header.Y = 4;
T.header.Z = 5;

%% Specular Point
S = scatterCoeff(R, T, dirData, refData, prn, elev);
S.data(any(S.data == 0, 2), :) = [];
Sxyz = S.data(:, S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);
S.data(:,S.header.brcs) = S.data(:,S.header.brcs)*3;
brcs = pow2db(S.data(:,S.header.brcs));
area = pow2db(S.data(:,S.header.area));

%% Dielectric
fprintf('Calculating surface properties...')
q = qvec(R, T, S);
Rcs = invKAGO(S, q, mss);
eps = invFresnel(Rcs, S);
fprintf('Done\n')

%% Plot
% plotBRCS(S, R, median(S_lla, 1))
plotDielectric(brcs,Rcs,eps)
% figure(11); hold on
% plot(dirData)
% plot(refData)
% generateKML(kmlFile, S)

