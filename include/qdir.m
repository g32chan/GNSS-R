function q = qdir(inc, scatt)
% inc: incident angle [deg]
% scatt: scattering angle(s) [deg]
% q: normalized magnitude of scattering vector(s)

i = deg2rad(inc);
s = deg2rad(scatt);
qx = sin(s)-sin(i);
qy = cos(s)+cos(i);

q = zeros(1,length(s));
for n = 1:length(s)
    q(n) = norm([qx(n) qy(n)]);
end

end

