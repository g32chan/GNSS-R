clear; close all; clc;

[~,~,raw] = xlsread('C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\Table 6-4 (Gleason).xlsx','Sheet1','A2:I19');
data = reshape([raw{:}],size(raw));
clearvars raw;

igsFile = igsDownload(1297, 201291);
igsData = igsRead(igsFile);
navData = importData('Nav_RO.csv');
tow = navData.data(:, navData.header.tow);
Rxyz = navData.data(:, navData.header.X:navData.header.Z);

theta = zeros(18, 1);
A = zeros(18, 1);
Txyz = zeros(18, 3);
Sxyz = zeros(18, 3);
Rt = zeros(18, 1);
Rr = zeros(18, 1);
R = zeros(18, 1);
for i = 1:18
    Txyz(i,:) = getLocation(tow(i), 22, igsData);
    Sxyz(i,:) = specularPoint(Rxyz(i,:),Txyz(i,:),0);
    theta(i) = snell(Rxyz(i,:), Txyz(i,:), Sxyz(i,:));
    Rt(i) = dist3(Txyz(i,:),Sxyz(i,:));
    Rr(i) = dist3(Rxyz(i,:),Sxyz(i,:));
    R(i) = -pow2db(Rt(i)^2*Rr(i)^2);
    Rlla = ecef2lla(Rxyz(i,:));
    A(i) = pow2db(gpsFootprint(Rlla(3), 90-theta(i), 'isorange'));
end

time = data(:,1);
SNR = data(:,2);
% theta = data(:,3);
% A = data(:,4);
% R = data(:,5);
EIRP = data(:,6);
Gr = data(:,7);
S = data(:,8);
sigma = data(:,9);
% sigma_hat = zeros(size(sigma));

kb = 1.38e-23;
F = db2pow(2.5);
T = 290*(F-1);
B = 1e3;
% N = pow2db(kb*T*B);
N = -142.2;
Gpr = pow2db(1023);
lambda = 299792458/1.57542e9;
k = pow2db((1.5*(4*pi)^3)/(lambda^2));

% Ht = 20200000;
% Hr = 680000;
% Rt = Ht./cosd(theta);
% Rr = Hr./cosd(theta);
% R = -pow2db(Rt.^2.*Rr.^2);
sigma_hat = k-Gpr+N+SNR-EIRP-Gr-abs(S)-A+abs(R);

figure
plot(time,sigma,time,sigma_hat)
xlabel('Second')
ylabel('\sigma^0 [dB]')
legend('Estimate from thesis','Calculated','location','best')

figure
plot(time,abs(sigma-sigma_hat))
xlabel('Second')
ylabel('Error [dB]')


%%
clear; close all; clc
SNR = -2.7;
Gpr = 30.1;
N = -142.2;
K = 49.15;
A = 90.33;
R = -285.27;
Pt = 27.43;
Gr = 11.54;
S = -1.62;


count = int16(0);

for i=1:512
    add = zeros(9,1);
    for j = 1:9
        if bitget(count,j) == 1
            add(j) = 1;
        elseif bitget(count,j) == 0
            add(j) = -1;
        end
    end
    sigma(i) = SNR * add(1) + ...
               Gpr * add(2) + ...
               N * add(3) + ...
               K * add(4) + ...
               A * add(5) + ...
               R * add(6) + ...
               Pt * add(7) + ...
               Gr * add(8) + ...
               S * add(9);
    if abs(abs(sigma(i))-9.5) < 1
        sigma(i)
    end
    count = count + 1;
end



