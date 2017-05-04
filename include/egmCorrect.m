function out = egmCorrect(xyz)
% xyz: ECEF coordinates
% out: corrected ECEF coordinates

[Z, refvec] = egm96geoid(1);

lla = ecef2lla(xyz);
temp = lla;
for i = 1:length(lla)
    corr = ltln2val(Z,refvec,lla(i,1),lla(i,2));
    temp(i,3) = lla(i,3)-corr;
end

out = lla2ecef(temp);

end
