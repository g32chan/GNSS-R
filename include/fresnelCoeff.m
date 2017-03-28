function [Rvv, Rhh] = fresnelCoeff(eps, theta)
% eps: relative complex permittivity
% theta: incident angle [deg]
% Rvv: vertical component
% Rhh: horizontal component

cs=cosd(theta);
sn=sind(theta);
Rvv=(eps.*cs-sqrt(eps-sn.^2))./(eps.*cs+sqrt(eps-sn.^2));
Rhh=(cs-sqrt(eps-sn.^2))./(cs+sqrt(eps-sn.^2));

end

