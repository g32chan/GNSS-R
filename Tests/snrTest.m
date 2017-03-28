%% Configure
clear; close all; clc
type = 'Ocean';
dirFile = [type ' Dir'];
refFile = [type ' Ref'];
t = 19;
dir = zeros(t,1);
ref = zeros(t,1);
for sec = 1:t
    %% Direct
    data = load(['Daaxa\' dirFile '\DaaxaOut' sprintf('%2d', sec) '.dat']);
    data = data(:,6:end);
    % figure
    % surf(data)

    %% Signal Power
    n = size(data,1);
    peak = zeros(n,2);
    for i = 1:n
        [M,I] = max(data(i,:));
        peak(i,:) = [M,I];
    end

    %% Noise Power
    Pn = zeros(n,1);
    for i = 1:n
        Pn(i) = mean(data(i,1:peak(i,2)-5));
    end

    snr = pow2db((peak(:,1)-Pn)./Pn);
    dir(sec) = mean(snr);
    
    %% Reflected
    data = load(['Daaxa\' refFile '\DaaxaOut' sprintf('%2d', sec) '.dat']);
    data = data(:,6:end);
    % figure
    % surf(data)

    %% Signal Power
    n = size(data,1);
    peak = zeros(n,2);
    for i = 1:n
        [M,I] = max(data(i,:));
        peak(i,:) = [M,I];
    end

    %% Noise Power
    Pn = zeros(n,1);
    for i = 1:n
        Pn(i) = mean(data(i,1:peak(i,2)-5));
    end

    snr = pow2db((peak(:,1)-Pn)./Pn);
    ref(sec) = mean(snr);
end

figure; hold on;
plot(dir)
plot(ref)
title(type)
xlabel('Time [sec]')
ylabel('SNR [dB]')


