function q = qdir(i, s)
% i: incident angle [deg]
% s: scattering angles [deg]
% q: scattering vectors

qx = sind(s)-sind(i);
qy = cosd(s)+cosd(i);

q = [qx; qy];

end

