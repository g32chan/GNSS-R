ch = 3;
s = 4;
Ip = trackResults(ch).I_P;
Qp = trackResults(ch).Q_P;
Itemp = Ip((s-1)*1000+1:s*1000);
Qtemp = Qp((s-1)*1000+1:s*1000);

figure
subplot(2,1,1)
plot(Itemp)
subplot(2,1,2)
plot(Qtemp)

% figure; hold on;
% % plot(Itemp,Qtemp)
% % plot(Itemp,Qtemp,'.')
% comet(Itemp,Qtemp)

% Z = Ip+1i*Qp;
Z = Itemp+1i*Qtemp;
phase = angle(Z);
mag = abs(Z);

figure
subplot(2,1,1)
plot(phase)
subplot(2,1,2)
plot(unwrap(phase))
