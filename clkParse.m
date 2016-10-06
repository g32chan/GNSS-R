function out = clkParse(filename)
% filename: SiRF clock data filename
% out: Output data

%% Import data
[~, name, ext] = fileparts(filename);
fprintf('Importing %s%s...', name, ext)
out = importData(filename);

%% Unit correction
out.data(:, out.header.ToW) = out.data(:, out.header.ToW) / 100;
out.data(:, out.header.ClockBias) = out.data(:, out.header.ClockBias) / 1e9;
out.data(:, out.header.Est_GPSTime) = out.data(:, out.header.Est_GPSTime) / 1000;
fprintf('Done\n')

end

