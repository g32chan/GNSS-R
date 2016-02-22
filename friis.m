function Pr = friis(P, lambda, R)
% P: Transmitted power and gain [W]
% lambda: Wavelength [m]
% R: Propagation distance [m]
% Pr: Received power [W]

Pr=P*(lambda/4/pi/R)^2;


end

