clear; close all; clc

%% Configure
flag = 2;
if flag == 1
    prn = 13;
    e = 0;
    n = 8;
    offset = 1;
    mss = 0.0001;
    navFile = 'Nav_RI.csv';
%     dirFile = 'DaaxaCN0 ice dir.dat';
%     refFile = 'DaaxaCN0 ice ref.dat';
    dirFile = 'Ice Dir';
    refFile = 'Ice Ref';
    kmlFile = 'KML\DaaxaIce.kml';
elseif flag == 2
    prn = 22;
    e = 0;
    n = 21;
    offset = 0; %3
    mss = 0.005; %0.0075
    navFile = 'Nav_RO.csv';
%     dirFile = 'DaaxaCN0 ocean dir.dat';
%     refFile = 'DaaxaCN0 ocean ref.dat';
    dirFile = 'Ocean Dir';
    refFile = 'Ocean Ref';
    kmlFile = 'KML\DaaxaOcean.kml';
elseif flag == 3
    prn = 15;
    e = 396;
    n = 20;
    offset = 2;
    mss = 0.001;
    navFile = 'Nav_RL.csv';
%     dirFile = 'DaaxaCN0 land dir svn15.dat';
%     refFile = 'DaaxaCN0 land ref svn15.dat';
    dirFile = 'Land SVN15 Dir';
    refFile = 'Land SVN15 Ref';
    kmlFile = 'KML\DaaxaLand15.kml';
elseif flag == 4
    prn = 18;
    e = 335;
    n = 20;
    offset = 2;
    mss = 0.0005;
    navFile = 'Nav_RL.csv';
%     dirFile = 'DaaxaCN0 land dir svn18.dat';
%     refFile = 'DaaxaCN0 land ref svn18.dat';
    dirFile = 'Land SVN18 Dir';
    refFile = 'Land SVN18 Ref';
    kmlFile = 'KML\DaaxaLand18.kml';
end    

%% Power
% cn0ref  = load(refFile);
% cn0dir  = load(dirFile);
% 
% tempref = cn0ref(:,6:end);
% tempref = pow2db(tempref);
% [maxref, idxref] = max(tempref(:));
% 
% tempdir = cn0dir(:,6:end);
% tempdir = pow2db(tempdir);
% [maxdir, idxdir] = max(tempdir(:));

dirData = zeros(1,n);
refData = zeros(1,n);
for i = 1:n-offset
    try
        dirTemp = load(['Daaxa\' dirFile '\DaaxaCN0' sprintf('%2d', i) '.dat']);
        refTemp = load(['Daaxa\' refFile '\DaaxaCN0' sprintf('%2d', i) '.dat']);
    catch
        continue
    end
    dirTemp = dirTemp(:,6:end);
    refTemp = refTemp(:,6:end);
    for j = 1:size(dirTemp,1)
        dirData(i+offset) = dirData(i+offset) + max(dirTemp(j,:));
        refData(i+offset) = refData(i+offset) + max(refTemp(j,:));
    end
    dirData(i+offset) = pow2db(dirData(i+offset) / size(dirTemp,1));
    refData(i+offset) = pow2db(refData(i+offset) / size(refTemp,1));
end

%% Receiver
navData = importData(navFile);
time = navData.data(:, navData.header.tow);
pos = navData.data(:, navData.header.X:navData.header.Z);
bias = navData.data(:, navData.header.bias);
wn = navData.data(1, navData.header.wn);
tow = time(1);
n = length(time);

R.data = [time pos bias];
R.header.time = 1;
R.header.X = 2;
R.header.Y = 3;
R.header.Z = 4;
R.header.B = 5;

%% Transmitter
igsFile = igsDownload(wn, tow);
igsData = igsRead(igsFile);

satpos = zeros(3, n);
for i = 1:n
    [satpos(:, i), ~] = getLocation(time(i), prn, igsData);
end
T.data = [time repmat(prn, n, 1) satpos'];
T.header.time = 1;
T.header.prn = 2;
T.header.X = 3;
T.header.Y = 4;
T.header.Z = 5;

%% Specular Point
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
Txyz = T.data(:, T.header.X:T.header.Z);
Rxyz = R.data(:, R.header.X:R.header.Z);
for i = 1:size(S.data,1)
    Ttemp = Txyz(i, :);
    t = T.data(i, T.header.time);
    idx = time == t;
    Rtemp = Rxyz(idx, :);
    dir = dirData(i);
    if dir == 0
        continue
    end
    ref = refData(i);
%     [Stemp, theta, sigma0, area] = scatterCoeff(Rtemp, Ttemp, maxdir, maxref, 0);
    [Stemp, theta, sigma0, area] = scatterCoeff(Rtemp, Ttemp, dir, ref, e);
    S.data(i, S.header.X:S.header.Z) = Stemp;
    S.data(i, S.header.theta) = theta;
    S.data(i, S.header.brcs) = sigma0;
    S.data(i, S.header.area) = area;
end
S.data(any(S.data == 0, 2), :) = [];
Sxyz = S.data(:, S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);
brcs = pow2db(S.data(:,S.header.brcs));
area = pow2db(S.data(:,S.header.area));
fprintf('Done\n')

%% Dielectric
fprintf('Calculating surface properties...')
q = qvec(R, T, S);
Rcs = invKAGO(S, q, mss);
e = invFresnel(Rcs, S);
fprintf('Done\n')

%% Plot
plotBRCS(S, R, median(S_lla, 1))
figure(10); hold on
temp = dirData;
temp(temp == 0) = NaN;
plot(temp)
temp = refData;
temp(temp == 0) = NaN;
plot(temp)
% generateKML(kmlFile, S)

test
