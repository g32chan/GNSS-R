function [R, T, DOP] = getPositions(input, igs, clk)
% input: Input data
% igs: IGS data
% clk: Clock data
% R: Receiver positions
% T: Transmitter positions
% DOP: Dilution of precision

%% Check inputs
if nargin < 3
    clk = [];
end

%% Initialize
c = 299792458;

id = input.header.Satellite;
gpst = input.header.GPSTime;
pr = input.header.CarrierPhase;
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
    clkBias = [];
    if ~isempty(clk)
        idx = clk.data(:, clk.header.ToW) == t;
        clkBias = clk.data(idx, clk.header.ClockBias) * c;
        clkBias = repmat(clkBias, size(satBias));
    end
    if isempty(clkBias)
        clkBias = zeros(size(satBias));
    end
    
    % Calculate receiver location
    prAdj = temp(:, pr) + satBias - clkBias;
    [Rxyz(i, :), dop] = leastSquarePos(satpos, prAdj, 'Borre');   % Use Borre
%     [Rxyz(i, :), dop] = leastSquarePos(satpos, prAdj, 'Chong');   % Use Chong
    
    % Check DOP
    DOP(i, :) = dop;
    M = max(dop);
    if M > 10
        fprintf('DOP is bad: %f (t=%i)', M, t)
    end
end

%% Interpolate missing data
first = min(time);
last = max(time);
timevec = (first:1:last)';
Rxyzb = interp1(time, Rxyz, timevec, 'pchip');
DOP = interp1(time, DOP, timevec, 'pchip');

%% Prepare output
R.header.time = 1;
R.header.X = 2;
R.header.Y = 3;
R.header.Z = 4;
R.header.B = 5;
R.data = [round(timevec) Rxyzb];

T.header.time = 1;
T.header.prn = 2;
T.header.X = 3;
T.header.Y = 4;
T.header.Z = 5;
T.data = [round(data(:, gpst)) data(:, id) Txyz];

fprintf('Done\n')

end

