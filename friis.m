function Pr = friis(Pt, lambda, R)
% Pt: Transmitted power and gain [W]
% lambda: Wavelength [m]
% R: Propagation distance [m]
% Pr: Received power [W]

Pr=Pt*(lambda/4/pi/R)^2;


end

