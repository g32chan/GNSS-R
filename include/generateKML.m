function generateKML(filename, S)
% filename: name of output file
% S: specular data

fprintf('Generating KML file...')
brcs = pow2db(S.data(:,S.header.brcs));
Sxyz = S.data(:,S.header.X:S.header.Z);
S_lla = ecef2lla(Sxyz);

cm = jet(64);
brcs_min = min(brcs);
brcs_max = max(brcs);
idx = floor(1+(brcs - brcs_min)/(brcs_max - brcs_min) * 63);
colors = cm(idx,:);

iconFile = 'http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png';
kmlwritepoint(filename, S_lla(:, 1), S_lla(:, 2), 'Name', '', 'Icon', iconFile, 'IconScale', 0.5, 'Color', colors)

status = system(['python removeKMLlabels.py ' filename]);
if status ~= 0
    warning('Could not remove labels from KML file');
end
fprintf('Done\n')

end

