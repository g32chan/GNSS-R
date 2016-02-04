function [t] = gps2utc(wn, tow, leapseconds)
if nargin < 3
    leapseconds = 17; % As of June 30, 2015
end

days = wn * 7 + floor(tow / 86400);
seconds = rem(tow, 86400) - leapseconds;

L = calendarDuration(0,0,days,0,0,seconds);
t = datetime(1980,1,6,0,0,0) + L;
end

