function [P, clk] = getLocation(t, PRN, igs)
% Modified from precise_orbit_interp.m by Xiaofan Li (2008)
% t: GPS time [sec]
% PRN: Satellite ID
% igs: IGS data
% P: Location of PRN at t in ECEF
% clk: Clock bias of PRN at t

c = 299792458;

i = find(igs.data(:, igs.col.prn) == PRN);
X = igs.data(i, igs.col.X);
Y = igs.data(i, igs.col.Y);
Z = igs.data(i, igs.col.Z);
bias = igs.data(i, igs.col.B);
time = igs.data(i, igs.col.tow);
[~, idx] = min(abs(t - time));

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
w = 2*pi/period;
target = t/86400;
N = (terms-1)/2;
for n = 1:N
  j = 2+(n-1)*2;
  A(:,j) = sin(n*w*Timei);
  A(:,j+1) = cos(n*w*Timei);
  B(j) = sin(n*w*target);
  B(j+1) = cos(n*w*target);
end

X_coeffs = A\X(k);
Y_coeffs = A\Y(k);
Z_coeffs = A\Z(k);

P = 1000*[B*X_coeffs B*Y_coeffs B*Z_coeffs];

% Interpolate clock
b = [];
T = [];
for i = 1:length(bias)
    if bias(i) ~= 999999.999999
        b = [b, bias(i)];
        T = [T, time(i)];
    end
end
if ~isempty(T) || ~isempty(b)
    clk = interp1(T, b, t) * c * 1e-6;
else
    clk = 0;
end

end

