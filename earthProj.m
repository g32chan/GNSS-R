function r = earthProj(pos)
% pos: Position in WGS84
% r: Radius of earth projected from pos [m]

% Load common parameters
parameters;

% Calculate latitude
theta = asin(pos(3)/norm(pos)); % Z-axis / norm

% Calculate radius
temp1 = 1 - WGS84_e^2;
temp2 = 1 - (WGS84_e*cos(theta))^2;
r = WGS84_a*sqrt(temp1/temp2);

end

