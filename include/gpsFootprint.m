function area = gpsFootprint(h, e, flag)
% h: height of receiver [m]
% e: elevation angle [deg]
% flag: method
% area: area of footprint [m^2]

c = 299792458;
f = 1.57542e9;
lambda = c/f;

if h < 0
    warning('Height less than zero')
    h = 0;
end

if flag
    % First Iso-Range Ellipse
    CArate = 1023000;
    tau = 1;
    d = 1/CArate*c*tau;
    b = sqrt(2*h*d/sind(e));
    a = b/sind(e);    
else
    % First Fresnel Zone, Area of an Ellipse
    b = sqrt(lambda*h./sind(e) + (lambda/2./sind(e)).^2);
    a = b./sind(e);
end

area = pi.*a.*b;
if area < 0
    error('Area less than zero')
end

end

