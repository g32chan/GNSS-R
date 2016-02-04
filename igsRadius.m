clear; close all; clc

% Read data
data = csvread('igs18605.sp3.csv');
t = datestr(datetime(data(1,1), data(1,2), data(1,3)), 'mmmm dd, yyyy');
prns = data(2,:);
epochs = data(3,1);
sats = data(3,2);
data(1:3,:) = [];
data(:,4:end) = [];
data = reshape(data,sats,epochs,3);

% Plot distances
r = zeros(sats,epochs);
o = [0 0 0];
for e = 1:epochs
    for s = 1:sats
        r(s,e) = dist3(o, data(s,e,:));
%         r(s,e)=sqrt(data(s,e,1)^2+data(s,e,2)^2+data(s,e,3)^2);
    end
end
figure(1)
hold on;
for s = 1:sats
    plot(r(s,:))
end
ylabel('Distance [km]');
xlabel('Epoch [900 sec]');
title(['GPS Satellite Orbits for ' t]);

% Plot orbits
slc_lla = [43.471916 -80.544992 0];
slc = lla2ecef(slc_lla)./1e3;
figure(2)
hold on;
grid on;
plot3(slc(1), slc(2), slc(3), 'r*')
for s = 1:sats
    plot3(data(s,:,1), data(s,:,2), data(s,:,3))
end
a = 6378.137;
f = 1/298.257223563;
b = a*(1-f);
[x,y,z] = ellipsoid(0,0,0,a,a,b);
surf(x,y,z)
xlabel('WGS84 x-axis [km]');
ylabel('WGS84 y-axis [km]');
zlabel('WGS84 z-axis [km]');

% Plot visible satellites
v = [2 3 6 12 17 28];
figure(3)
hold on;
grid on;
plot3(slc(1), slc(2), slc(3), 'r*')
for s = 1:sats
    if ismember(prns(s), v)
        plot3(data(s,73:75,1), data(s,73:75,2), data(s,73:75,3), 'k')
        d = dist3(slc, data(s,74,:));
        disp(['Calculated pseudorange for satellite ' num2str(prns(s)) ' is ' num2str(d) ' km'])
    else
        plot3(data(s,73:75,1), data(s,73:75,2), data(s,73:75,3), 'c')
    end
end
surf(x,y,z)
xlabel('WGS84 x-axis [km]');
ylabel('WGS84 y-axis [km]');
zlabel('WGS84 z-axis [km]');
