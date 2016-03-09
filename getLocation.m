function P = getLocation(t, PRN, sp3)
% Modified from precise_orbit_interp.m by Xiaofan Li (2008)
% t: UTC time
% PRN: Satellite ID
% sp3: SP3 data
% P: Location of PRN at t in ECEF

i = find(sp3.data(:,3) == PRN);
X = sp3.data(i,4);
Y = sp3.data(i,5);
Z = sp3.data(i,6);
time = sp3.data(i,2);
[~,idx] = min(abs(t - time));

if idx < 5
    k = 1:9;
elseif idx > length(time) - 4
    k = length(time)-8:length(time);
else
    k = idx-4:idx+4;
end


terms = 9;
Nmeas = length(k);
A = zeros(Nmeas, terms);
A(:,1) = ones(Nmeas,1); 
B = zeros(1, terms);
B(1) = 1;
Timei = time(k)/86400;

sidereal_day = 0.99726956634;
period = sidereal_day;
W = 2 * pi / period;
target = t/86400;
N = (terms-1)/2;
for n = 1:N
  j = 2+(n-1)*2;
  NW = n*W;
  A(:,j) = sin(NW*Timei);
  A(:,j+1) = cos(NW*Timei);
  B(j) = sin(NW*target);
  B(j+1) = cos(NW*target);
end

X_coeffs = A\X(k);
Y_coeffs = A\Y(k);
Z_coeffs = A\Z(k);

P = 1000*[B*X_coeffs B*Y_coeffs B*Z_coeffs];

end

