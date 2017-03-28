% clear; close all; clc
num = 2;
in = load(['C:\Users\gary\workspace\Daaxa\DaaxaIQ' sprintf('%2d', num) '.dat']);
data = in(:,6:end);
I = data(:,1:2:end);
Q = data(:,2:2:end);

[Imax,Im] = max(abs(I),[],2);
[Qmax,Qm] = max(abs(Q),[],2);

% figure
% surf(I)
% figure
% surf(Q)
Ism = round(smooth(Im,55,'rlowess'));
Qsm = round(smooth(Qm,55,'rlowess'));
% figure
% subplot(2,1,1); hold on;
% plot(Im)
% plot(Ism)
% subplot(2,1,2); hold on;
% plot(Qm)
% plot(Qsm)
Ip = zeros(size(Ism));
Qp = zeros(size(Qsm));
for i = 1:size(Ism,1)
    Ip(i) = I(i,Ism(i));
    Qp(i) = Q(i,Qsm(i));
end
% figure
% subplot(2,1,1)
% plot(Ip)
% subplot(2,1,2)
% plot(Qp)

% M = 20;
% K = 50;
% mu = zeros(K,size(data,2)/2);
% for k = 1:K
%     front = (k-1)*M+1;
%     back = k*M;
%     Itemp = I(front:back,:);
%     Qtemp = Q(front:back,:);
%     Isum = sum(Itemp,1);
%     Qsum = sum(Qtemp,1);
%     NBP = Isum.^2+Qsum.^2;
%     WBP = sum(Itemp.^2+Qtemp.^2,1);
%     mu(k,:) = NBP./WBP;
% end
% muavg = mean(mu,1);
% % cn0 = pow2db((muavg-1)./(M-muavg).*1000);

P = pow2db(sum(Ip.^2+Qp.^2)/1000);

