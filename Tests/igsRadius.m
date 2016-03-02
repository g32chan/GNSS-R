clear; close all; clc

% Configure script
filename = 'C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\IGS\igr18862.sp3.csv';
v = [1 7 8 11 13 17 28 30];
time = 2;

% Read data
data = csvread(filename);
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
figure(3)
hold on;
grid on;
plot3(slc(1), slc(2), slc(3), 'r*')
time = time*4:time*4+2;
for s = 1:sats
    if ismember(prns(s), v)
        plot3(data(s,time,1), data(s,time,2), data(s,time,3), 'k')
        d = dist3(slc, data(s,time(2),:));
        disp(['Calculated pseudorange for satellite ' num2str(prns(s)) ' is ' num2str(d) ' km'])
    else
        plot3(data(s,time,1), data(s,time,2), data(s,time,3), 'c')
    end
end
surf(x,y,z)
xlabel('WGS84 x-axis [km]');
ylabel('WGS84 y-axis [km]');
zlabel('WGS84 z-axis [km]');
