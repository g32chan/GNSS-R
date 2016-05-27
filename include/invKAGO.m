function R = invKAGO(sigma, q, mss)
% sigma: radar cross section
% q: scattering vector
% mss: mean square slope
% R: Fresnel reflection coefficient

x=-q(1)/q(3);
y=-q(2)/q(3);
PDF = 1/(2*mss)*exp(-(x^2+y^2)/(2*mss));

temp = (norm(q)/q(3))^4;

R = sqrt(sigma/temp/PDF);

end

