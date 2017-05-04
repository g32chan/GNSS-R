clear; close all; clc

dirData = sirfParse('270616_144300_ttyUSB1_results.csv', 0);
refData = sirfParse('270616_144300_ttyUSB0_results.csv', 0);

prns = intersect(dirData.PRN, refData.PRN);
time = (dirData.data(1,dirData.header.GPSTime):dirData.data(end,dirData.header.GPSTime))';

% for i = 1:length(prns)
prn = prns(1);
dir = zeros(length(time)*10, 1);
ref = zeros(length(time)*10, 1);
for t = 1:length(time)
    sec = time(t);

    idx = find(dirData.data(:, dirData.header.GPSTime) == sec & dirData.data(:, dirData.header.Satellite) == prn);
    if isempty(idx)
        temp = zeros(10,1);
    else
        temp = dirData.data(idx, dirData.header.CNR1:dirData.header.CNR10);
    end
    dir((t-1)*10+1:t*10) = temp;

    idx = find(refData.data(:, refData.header.GPSTime) == sec & refData.data(:, refData.header.Satellite) == prn);
    if isempty(idx)
        temp = zeros(10,1);
    else
        temp = refData.data(idx, refData.header.CNR1:refData.header.CNR10);
    end
    ref((t-1)*10+1:t*10) = temp;
end
dir(dir==0) = nan;
ref(ref==0) = nan;
figure; hold on
plot(dir)
plot(ref)
plot(smooth(dir,0.075,'rloess'))
plot(smooth(ref,0.075,'rloess'))
plot(round(smooth(dir,0.075,'rloess')))
plot(round(smooth(ref,0.075,'rloess')))
title(['CNR for PRN ' num2str(prn)])
xlabel('Elapsed Time [sec*10]')
ylabel('CNR [dB-Hz]')
% dir = round(smooth(dir,0.075,'rloess'));
% ref = round(smooth(ref,0.075,'rloess'));
% end

%%
% Rxyz = lla2ecef([43.47474 -80.53864 376]);
% pos = repmat(Rxyz,length(time),1);
% bias = zeros(length(time),1);
% R.data = [time pos bias];
% R.header.time = 1;
% R.header.X = 2;
% R.header.Y = 3;
% R.header.Z = 4;
% R.header.B = 5;
% 
% %%
% igsData = igsRead(igsDownload(dirData.wn, dirData.tow));
% Txyz = zeros(length(time),3);
% Sxyz = zeros(length(time),3);
% theta = zeros(length(time),1);
% brcs = zeros(length(time),1);
% area = zeros(length(time),1);
% for t = 1:length(time)
%     [Txyz(t,:),~] = getLocation(time(t), prn, igsData);
%     dirTemp = mean(dir((t-1)*10+1:t*10),'omitnan');
%     refTemp = mean(ref((t-1)*10+1:t*10),'omitnan');
%     [Sxyz(t,:), theta(t), brcs(t), area(t)] = scatterCoeff(Rxyz, Txyz(t,:), dirTemp, refTemp, 337);
% end
% 
% T.data = [time repmat(prn, length(time), 1) Txyz];
% T.header.time = 1;
% T.header.prn = 2;
% T.header.X = 3;
% T.header.Y = 4;
% T.header.Z = 5;
% 
% S.data = [time repmat(prn, length(time), 1) Sxyz theta brcs area];
% S.header.time = 1;
% S.header.prn = 2;
% S.header.X = 3;
% S.header.Y = 4;
% S.header.Z = 5;
% S.header.theta = 6;
% S.header.brcs = 7;
% S.header.area = 8;
% 
% area = pow2db(area);
% brcs = pow2db(brcs);
% 
% %%
% mss = .2;
% q = qvec(R, T, S);
% Rcs = invKAGO(S, q, mss);
% eps = invFresnel(Rcs, S);
% plotDielectric(brcs,Rcs,eps)
% generateKML('KML\test.kml', S)

