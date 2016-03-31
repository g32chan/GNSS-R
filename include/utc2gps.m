function [wn, tow] = utc2gps(t, leapseconds)
% t: UTC time
% wn: Week number
% tow: Time of week [sec]

if nargin < 2
    leapseconds = 17; % As of June 30, 2015
end

L = t - datetime(1980,1,6,0,0,0,'TimeZone','UTC');
L = seconds(L);
wn = floor(L/86400/7);
tow = L - wn*7*86400 + leapseconds;

end

