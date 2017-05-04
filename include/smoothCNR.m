function cnr = smoothCNR(data, header)
% data: Input data
% header: Input data header
% cnr: Smoothed CNRs

time = round(data(1,header.GPSTime):data(end,header.GPSTime));
prns = unique(data(:,header.Satellite));
cnr = zeros(size(data,1),1);

for i = 1:length(prns)
    prn = prns(i);
    vec = zeros(length(time),1);
    for t = 1:length(time)
        sec = time(t);
        idx = find(data(:,header.Satellite) == prn & round(data(:,header.GPSTime)) == sec);
        if isempty(idx)
            temp = zeros(10,1);
        else
            temp = data(idx, header.CNR1:header.CNR10);
        end
        vec((t-1)*10+1:t*10) = temp;
    end
    vec(vec == 0) = nan;
    vec = smooth(vec,0.075,'rloess');
    for t = 1:length(time)
        sec = time(t);
        idx = data(:,header.Satellite) == prn & round(data(:,header.GPSTime)) == sec;
        cnr(idx) = mean(vec((t-1)*10+1:t*10));
    end
end

end

