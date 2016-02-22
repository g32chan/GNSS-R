function [Rco, Rcross] = cocross(Rvv, Rhh)
% Rvv: vertical component
% Rhh: horizontal component
% Rco: co-polarization
% Rcross: cross-polarization

Rco=(Rvv+Rhh)/2;
Rcross=(Rvv-Rhh)/2;

end

