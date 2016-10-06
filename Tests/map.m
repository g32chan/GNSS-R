clear; close all; clc

%% EGM96 Polar Model
load coast
name = 'ww15mgh.grd';
if exist(name, 'file') == 0
    fname = [name '.z'];
    fh = fopen(fname, 'wb');
    jurl = java.net.URL('http://earth-info.nga.mil/GandG/wgs84/gravitymod/egm96/ww15mgh.grd.z');
    is = jurl.openStream;
    disp('Downloading EGM model...')
    while true
        b = is.read;
        if b == -1
            break
        end
        fwrite(fh, b, 'uint8');
    end
    is.close;
    fclose(fh);
    disp('Download complete')
    status = system(['7z e ' fname]);
    if status ~= 0
        error('Error decompressing')
    end
    if exist(name, 'file') == 2
        delete(fname);
    else
        error('File not found');
    end
end
[Z, refvec] = egm96geoid(1);
figure
h = axesm('MapProjection', 'eqdazim');
setm(h, 'origin', [90,0,0]);
setm(h, 'maplatlimit', [45 90]);
geoshow(Z, refvec, 'DisplayType', 'texturemap')
colormap('jet')
colorbar('southoutside')
geoshow(lat, long, 'color', 'k')

%% Specular points
filename = 'C:\Users\Gary\SkyDrive\Documents\WatSat\Payload\Data Processing\STK\WatSat LLA Position.txt.csv';
data = csvread(filename);
north = data(data(:,7)>=45,:);
lat = north(:,7);
lon = north(:,8);

figure
worldmap([45 90], [-180 180]);
geoshow('landareas.shp')

for i = 1:length(lat)
    geoshow(lat(i),lon(i),'Marker','.','MarkerEdgeColor','r')
end

% R = [-4069896.7033860330 -3583236.9637350840 4527639.2717581640];
% T = [-11178791.991294 -13160191.204988 20341528.127540];
% [S, theta] = specularPoint(R, T);
% S_lla = ecef2lla(S);
% P.Lat = S_lla(1)+10;
% P.Lon = S_lla(2);
% P.Geometry = deal('Point');
% % geoshow(P, 'Marker', 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k')
% % geoshow(P, 'Marker', 'o', 'MarkerSize', 3)
% geoshow(S_lla(1)+10,S_lla(2),'Marker','.','MarkerEdgeColor','r')

