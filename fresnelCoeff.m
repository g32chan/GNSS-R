function [Rvv, Rhh] = fresnelCoeff(eps, theta)
% eps: relative complex permittivity
% theta: incident angle [rad]
% Rvv: vertical component
% Rhh: horizontal component

cs=cos(theta);
sn=sin(theta);
Rvv=(eps.*cs-sqrt(eps-sn.^2))./(eps.*cs+sqrt(eps-sn.^2));
Rhh=(cs-sqrt(eps-sn.^2))./(cs+sqrt(eps-sn.^2));

end

