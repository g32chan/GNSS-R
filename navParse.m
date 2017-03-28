function out = navParse(filename)
% filename: SiRF navigation data filename
% out: Output data

%% Import data
[~, name, ext] = fileparts(filename);
fprintf('Importing %s%s...', name, ext)
out = importData(filename);

%% Unit correction
out.data(:, out.header.Vx) = out.data(:, out.header.Vx) / 8;
out.data(:, out.header.Vy) = out.data(:, out.header.Vy) / 8;
out.data(:, out.header.Vz) = out.data(:, out.header.Vz) / 8;
out.data(:, out.header.GPSWeek) = out.data(:, out.header.GPSWeek) + 1024;
out.data(:, out.header.ToW) = out.data(:, out.header.ToW) / 100;

%% Interpolate missing data
time = unique(out.data(:, out.header.ToW));
first = min(time);
last = max(time);
timevec = (first:1:last)';
temp = interp1(time, out.data(:, out.header.X:out.header.GPSWeek), timevec, 'pchip');
out.data = [temp timevec];

fprintf('Done\n')

end

