clear; close all; clc

h = worldmap([45 90], [-180 180]);
geoshow('landareas.shp')

R = [-4069896.7033860330 -3583236.9637350840 4527639.2717581640];
T = [-11178791.991294 -13160191.204988 20341528.127540];
[S, theta] = specularPoint(R, T);
S_lla = ecef2lla(S);
P.Lat = S_lla(1)+10;
P.Lon = S_lla(2);
P.Geometry = deal('Point');
% geoshow(P, 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k')
% geoshow(P, 'Marker', 'o', 'MarkerSize', 3)
geoshow(S_lla(1)+10,S_lla(2),'Marker','.','MarkerEdgeColor','r')

