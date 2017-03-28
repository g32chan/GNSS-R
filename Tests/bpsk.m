clear; close all; clc

prn = randi(32);
cacode = generateCAcode(prn);
cacode(cacode<0) = 0;
data = randi([0,1],1,50);
figure; plot(data)
code = repmat(cacode,1,1000);
data = imresize(data,size(code),'nearest');
signal = double(xor(data,code));
scatterplot(pskmod(signal,2))

fc = 5e6;
t = linspace(0,1,size(signal,2)+1);
carrier = cos(2*pi*fc*t(1:end-1));
raw = carrier.*signal;

time = linspace(0,0.001,1024);
carrCos = cos(2*pi*fc*time(1:1023));
carrSin = sin(2*pi*fc*time(1:1023));
I = zeros(1,1000);
Q = zeros(1,1000);
for i = 1:1000
    rawSignal = raw(1023*(i-1)+1:1023*i);
    I(i) = sum(cacode.*carrSin.*rawSignal);
    Q(i) = sum(cacode.*carrCos.*rawSignal);
end
figure; plot(I)
figure; plot(I,Q,'.')

scatterplot(pskdemod(raw,2))