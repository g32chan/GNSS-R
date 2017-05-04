function area = gpsFootprint(h, e, method)
% h: height of receiver [m]
% e: elevation angle [deg]
% method: method to use
% area: area of footprint [m^2]

c = 299792458;
f = 1.57542e9;
lambda = c/f;

if h < 0
    warning('Height less than zero')
    h = 0;
end

if strcmp(method, 'isorange')
    % First Iso-Range Ellipse
    CArate = 1023000;
    tau = 1;
    d = 1/CArate*c*tau;
    b = sqrt(2*h*d/sind(e));
    a = b/sind(e);
elseif strcmp(method, 'fresnel')
    % First Fresnel Zone
    b = sqrt(lambda*h./sind(e) + (lambda/2./sind(e)).^2);
    a = b./sind(e);
end

area = pi.*a.*b;

end

