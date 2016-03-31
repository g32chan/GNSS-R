function [R, T] = getPositions(input, clk, igs)
% input: Input data
% igs: IGS data
% R: Receiver positions
% T: Transmitter positions

c = 299792458;

header = input.header;
try
    id = header.Satellite;
    gpst = header.GPSTime;
    clkTime = clk.data(:,clk.header.ToW);
    bias = clk.data(:,clk.header.ClockBias);
catch
    id = header.Identifier;
    gpst = header.tow;
    clkTime = clk.data(:,clk.header.tow);
    bias = zeros(length(clkTime),1);
end
pr = header.Pseudorange;
% pr = header.CarrierPhase;
data = input.data;

time = unique(data(:,gpst));
Rxyz = zeros(length(time), 4);
Txyz = [];

for i = 1:length(time)
    t = time(i);
    temp = data(data(:,gpst)==t,:);
    PRNs = temp(:,id);
    [~,idx] = min(abs(t - clkTime));
    if sort(PRNs) ~= unique(PRNs)
        error('Multiple instances of satellite found')
    end
    satpos = zeros(3,length(PRNs));
    for j = 1:length(PRNs)
        satpos(:,j) = getLocation(t,PRNs(j),igs);
%         satpos(:,j) = getLocation(t-bias(idx),PRNs(j),igs);
%         satpos(:,j) = getLocation(t+130,PRNs(j),igs);
    end
    prCorr = bias(idx)*c;
    prAdj = temp(:,pr)-prCorr;
    [Rxyz(i,:), DOP] = leastSquarePos(satpos, prAdj);
    if max(DOP) > 10
        disp(['DOP is bad: ' num2str(max(DOP))])
    end
    Txyz = [Txyz; satpos'];
end

R.data = [time Rxyz];
R.header.time = 1;
R.header.X = 2;
R.header.Y = 3;
R.header.Z = 4;
R.header.B = 5;

T.data = [data(:,gpst) data(:,id) Txyz];
T.header.time = 1;
T.header.prn = 2;
T.header.X = 3;
T.header.Y = 4;
T.header.Z = 5;

end

