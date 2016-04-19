clear; close all; clc

igs = 'igs18605.sp3';
igsData = igsRead(igs);
header = igsData.col;
data = igsData.data;

sv = 10;
while sv==10 
    sv = randi(32);
end
tow = 432000+85500*rand();   %432000-517500

satpos = data(data(:,header.prn)==sv,:);
t = satpos(:,header.tow);
x = satpos(:,header.X)*1e3;
y = satpos(:,header.Y)*1e3;
z = satpos(:,header.Z)*1e3;
pos = getLocation(tow,sv,igsData);

figure; hold on
% plot(t,x,t,y,t,z)
plot(t,x,'.-',t,y,'.-',t,z,'.-')
plot(tow,pos(1),'bx',tow,pos(2),'rx',tow,pos(3),'gx','MarkerSize',10)
legend('X','Y','Z','location','best')
ylabel('ECEF coordinate')
xlabel('Time of Week')
title(['Trajectory for SVN' num2str(sv) ', Sep 4 2015, ToW=' num2str(tow)])

