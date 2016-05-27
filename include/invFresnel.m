function e = invFresnel(R, theta)
% R: Fresnel reflection coefficient
% theta: incident angle [deg]
% e: dielectric constant

tol = 1e-4;
e = 5;
K = 10;

[Rvv,Rhh]=fresnelCoeff(e,deg2rad(theta));
[~,Rcs]=cocross(Rvv,Rhh);

while abs(R-Rcs) > tol
    e = e+K*(R-Rcs);
    
    [Rvv,Rhh]=fresnelCoeff(e,deg2rad(theta));
    [~,Rcs]=cocross(Rvv,Rhh);
end
end

