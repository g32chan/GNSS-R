function ddr = tropo(satpos, pos)
% Modified from topocent.m and tropo.m by Kai Borre (2006)
% satpos: position of satellite
% pos: position of receiver
% ddr: tropospheric correction

%% Calculate elevation angle
lla = ecef2lla(pos');
lat = lla(1);
lon = lla(2);

% cl = cosd(lon);
% sl = sind(lon);
% cb = cosd(lat);
% sb = sind(lat);
% 
% F = [-sl -sb*cl cb*cl;
%       cl -sb*sl cb*sl;
%        0     cb    sb];

R1 = rotx(-(90 - lat));
R3 = rotz(-(90 + lon));

enu = R1 * R3 * (satpos - pos);
% enu = F' * (satpos - pos);
E = enu(1);
N = enu(2);
U = enu(3);

hor_dis = sqrt(E^2 + N^2);
e = sin(atan2(U, hor_dis));

%% Calculate correction
a_e   = 6378.137;     % semi-major axis of earth ellipsoid
b0    = 7.839257e-5;
e0sea = 0.0611 * 50 * 10^(7.5*(293-273.15) / (237.3+293-273.15));

e = max([0 e]);

tropo  = 0;
done   = 0;
refsea = 77.624e-6 / 293;
htop   = 1.1385e-5 / refsea;
refsea = refsea * 1013;

while 1
    rtop = (a_e+htop)^2 - a_e^2*(1-e^2);
    
    % check to see if geometry is crazy
    rtop = max([0 rtop]);
    
    rtop = sqrt(rtop) - a_e*e;
    a    = -e/htop;
    b    = -b0*(1-e^2) / htop;
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
    
    if done
        ddr = tropo; 
        break; 
    end
    
    done    = 1;
    refsea  = (371900.0e-6/293-12.92e-6)/293;
    htop    = 1.1385e-5 * (1255/293+0.05)/refsea;
    refsea  = refsea * e0sea;
end

end

