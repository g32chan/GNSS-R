clear; close all; clc;

elevFile = 'Elevation_Land18.csv';
elevData = importData(elevFile);

D = elevData.data(:,elevData.header.Distance);
E = elevData.data(:,elevData.header.Elevation);

figure
plot(D,E)

d = diff(D);
e = diff(E);
s = e./d;

figure
plot(s)

m = movvar(s,20);

figure
plot(m)

