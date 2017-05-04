function out = interpFix(input, time)
% input: Input data to interpolate
% time: Time vector to interpolate
% out: Output data

temp = unique(input.data(:, input.header.GPSTime));
if length(time) == length(temp)
    out = input;
    return
end

temp3 = [];
outPRN = [];
for i = 1:length(input.PRN)
    prn = input.PRN(i);
    idx = input.data(:, input.header.Satellite) == prn;
    temp1 = input.data(idx, :);
    if size(temp1, 1) == 1
        continue
    end
    temp2 = interp1(temp1(:, input.header.GPSTime), temp1, time, 'pchip');
    temp3 = [temp3; temp2];
    outPRN = [outPRN prn];
end
temp4 = sortrows(temp3,[3 1]);

out.header = input.header;
out.wn = input.wn;
out.tow = input.tow;
out.PRN = outPRN;
out.data = temp4;


end

