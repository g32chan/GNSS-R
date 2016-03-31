function ddr = tropo(satpos, pos)
% satpos: position of satellite
% pos: position of receiver
% ddr: tropospheric correction

%% Calculate elevation angle
lla = ecef2lla(pos');
lat = lla(1);
lon = lla(2);

cl  = cos(deg2rad(lon));
sl  = sin(deg2rad(lon));
cb  = cos(deg2rad(lat)); 
sb  = sin(deg2rad(lat));

F   = [-sl -sb*cl cb*cl;
        cl -sb*sl cb*sl;
        0    cb   sb];

local_vector = F' * (satpos-pos);
E   = local_vector(1);
N   = local_vector(2);
U   = local_vector(3);

hor_dis = sqrt(E^2 + N^2);
e = sin(atan2(U, hor_dis));

%% Calculate correction
a_e    = 6378.137;     % semi-major axis of earth ellipsoid
b0     = 7.839257e-5;
e0sea  = 0.0611 * 50 * 10^(7.5*(293-273.15) / (237.3+293-273.15));

if e < 0
    e = 0;
end

tropo   = 0;
done    = 'FALSE';
refsea  = 77.624e-6 / 293;
htop    = 1.1385e-5 / refsea;
refsea  = refsea * 1013;

while 1
    rtop = (a_e+htop)^2 - (a_e+0)^2*(1-e^2);
    
    % check to see if geometry is crazy
    if rtop < 0
        rtop = 0; 
    end 
    
    rtop = sqrt(rtop) - (a_e+0)*e;
    a    = -e/(htop-0);
    b    = -b0*(1-e^2) / (htop-0);
    rn   = zeros(8,1);

    for i = 1:8
        rn(i) = rtop^(i+1);
    end
    
    alpha = [2*a, 2*a^2+4*b/3, a*(a^2+3*b),...
        a^4/5+2.4*a^2*b+1.2*b^2, 2*a*b*(a^2+3*b)/3,...
        b^2*(6*a^2+4*b)*1.428571e-1, 0, 0];
    
    if b^2 > 1.0e-35
        alpha(7) = a*b^3/2; 
        alpha(8) = b^4/9; 
    end

    dr = rtop;
    dr = dr + alpha*rn;
    tropo = tropo + dr*refsea*1000;
    
    if strcmp(done, 'TRUE')
        ddr = tropo; 
        break; 
    end
    
    done    = 'TRUE';
    refsea  = (371900.0e-6/293-12.92e-6)/293;
    htop    = 1.1385e-5 * (1255/293+0.05)/refsea;
    refsea     = refsea * e0sea;
end

end

