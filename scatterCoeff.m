function [sigma]=scatterCoeff(R,T,dir,ref)
% R: Transmitter position in WGS84
% T: Receiver position in WGS84
% dir: SNR of direct signal
% ref: SNR of reflected signal
% sigma: Scattering coefficient

c=299792458;
f=1575.42e6;
lambda=c/f;

% Get specular point
[S,theta]=specularPoint(R,T);

% Calculate distances
Rd=dist3(R,T);
Rr=dist3(R,S);
Rt=dist3(T,S);
lla=ecef2lla(R');
h=lla(3);

% Calculate reflection area
[~,~,area]=gpsFootprint(lambda,h,deg2rad(90-theta));

% Calculate sigma
sigma=ref/dir*(Rt/Rd)^2*(4*pi*Rr^2)/area;

end