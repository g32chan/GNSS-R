function snr = calcSNR(data)
% data: input data
% snr: signal-to-noise ratio [dB]

n = size(data,1);
peak = zeros(n,2);
for i = 1:n
    [M,I] = max(data(i,:));
    peak(i,:) = [M,I];
end
Ps = zeros(n,1);
Pn = zeros(n,1);
for i = 1:n
    Pn(i) = mean(data(i,2:peak(i,2)-20));
    Ps(i) = mean(data(i,peak(i,2)-2:peak(i,2)+2));
end

% snr = mean(pow2db((Ps-Pn)./Pn));
snr = mean(pow2db((peak(:,1)-Pn)./Pn));

end

