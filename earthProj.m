function [ r ] = earthProj( pos )
% pos: Position in WGS84
% r: Radius of earth projected from pos [m]

% WGS84 Parameters
a = 6378137;            % Semimajor axis
f = 1/298.257223563;    % Flattening
% b = a*(1-f);            % Semiminor axis
e = sqrt(2*f-f^2);      % Eccentricity

% Calculate latitude
theta = asin(pos(3)/norm(pos)); % Z-axis / norm

% Calculate radius
temp1 = 1 - e^2;
temp2 = 1 - (e*cos(theta))^2;
r = a*sqrt(temp1/temp2);

end

