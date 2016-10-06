function [R, T, DOP] = getPositions(input, igs, clk)
% input: Input data
% igs: IGS data
% clk: Clock data
% R: Receiver positions
% T: Transmitter positions
% DOP: Dilution of precision

c = 299792458;

header = input.header;
try
    id = header.Satellite;
    gpst = header.GPSTime;
catch
    id = header.Identifier;
    gpst = header.tow;
end
% pr = header.Pseudorange;
pr = header.CarrierPhase;
data = input.data;

time = unique(data(:, gpst));
Rxyz = zeros(length(time), 4);
DOP = zeros(length(time), 5);
Txyz = [];

%% Calculate positions
fprintf('Calculating receiver position...')
for i = 1:length(time)
    % Get parameters
    t = time(i);
    temp = data(data(:, gpst) == t, :);
    PRNs = temp(:, id);
    if sort(PRNs) ~= unique(PRNs)
        error('Multiple instances of satellite found')
    end
    
    % Calculate transmitter locations
    n = length(PRNs);
    satpos = zeros(3, n);
    satBias = zeros(n, 1);
    for j = 1:n
        [satpos(:, j), satBias(j)] = getLocation(t, PRNs(j), igs);
    end
    Txyz = [Txyz; satpos'];
    
    % Calculate clock corrections
    idx = clk.data(:, clk.header.ToW) == t;
    clkBias = clk.data(idx, clk.header.ClockBias) * c;
    clkBias = repmat(clkBias, size(satBias));
    
    % Calculate receiver location
    prAdj = temp(:, pr) + satBias - clkBias;
    [Rxyz(i, :), dop] = leastSquarePos(satpos, prAdj, 1);   % Use Borre
%     [Rxyz(i, :), dop] = leastSquarePos(satpos, prAdj, 0);   % Use Chong
    
    % Check DOP
    DOP(i, :) = dop;
    M = max(dop);
    if M > 10
        fprintf('DOP is bad: %f (t=%i)', M, t)
    end
end

%% Prepare output
R.data = [round(time) Rxyz];
R.header.time = 1;
R.header.X = 2;
R.header.Y = 3;
R.header.Z = 4;
R.header.B = 5;

T.data = [round(data(:, gpst)) data(:, id) Txyz];
T.header.time = 1;
T.header.prn = 2;
T.header.X = 3;
T.header.Y = 4;
T.header.Z = 5;
fprintf('Done\n')

end

