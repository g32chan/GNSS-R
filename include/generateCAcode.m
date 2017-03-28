function cacode = generateCAcode(PRN)
% PRN: satellite PRN
% cacode: c/a code

n = 1023;

g2shift = [  5,   6,   7,   8,  17,  18, 139, 140, ...
           141, 251, 252, 254, 255, 256, 257, 258, ...
           469, 470, 471, 472, 473, 474, 509, 512, ...
           513, 514, 515, 516, 859, 860, 861, 862];

g2s = g2shift(PRN);

g1 = zeros(1, n);
reg = -1*ones(1, 10);

for i = 1:n
    g1(i) = reg(10);
    saveBit = reg(3)*reg(10);
    reg(2:10) = reg(1:9);
    reg(1) = saveBit;
end

g2 = zeros(1, n);
reg = -1*ones(1, 10);

for i = 1:n
    g2(i) = reg(10);
    saveBit = reg(2)*reg(3)*reg(6)*reg(8)*reg(9)*reg(10);
    reg(2:10) = reg(1:9);
    reg(1) = saveBit;
end

g2 = [g2((n-g2s+1):n), g2(1:(n-g2s))];

cacode = -(g1.*g2);


end
