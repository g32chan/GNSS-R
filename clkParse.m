function out = clkParse(filename, time)
% filename: SiRF clock data filename
% time: Time vector to interpolate
% out: Output data

%% Import data
[~, name, ext] = fileparts(filename);
fprintf('Importing %s%s...', name, ext)
out = importData(filename);

%% Unit correction
out.data(:, out.header.ToW) = out.data(:, out.header.ToW) / 100;
out.data(:, out.header.ClockBias) = out.data(:, out.header.ClockBias) / 1e9;
out.data(:, out.header.Est_GPSTime) = out.data(:, out.header.Est_GPSTime) / 1000;

%% Interpolate missing data
out.data = interp1(out.data(:, out.header.ToW), out.data, time, 'pchip');

fprintf('Done\n')

end

