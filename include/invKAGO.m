function R = invKAGO(S, q, mss)
% S: specular data
% q: scattering vector
% mss: mean square slope
% R: Fresnel reflection coefficient

R = zeros(size(S.data, 1), 1);
sigma = S.data(:, S.header.brcs);

for i = 1:size(S.data, 1)
    x=-q(i,1)/q(i,3);
    y=-q(i,2)/q(i,3);
    PDF = 1/(2*mss)*exp(-(x^2+y^2)/(2*mss));

    temp = (norm(q(i,:))/q(i,3))^4;

    R(i) = sqrt(sigma(i)/temp/PDF);
    if abs(R(i)) > 1
        warning('Reflection coefficient is out of bounds');
    end
end

end

