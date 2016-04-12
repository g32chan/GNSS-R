function [R, T] = getPositions(input, igs)
% input: Input data
% igs: IGS data
% R: Receiver positions
% T: Transmitter positions

header = input.header;
try
    id = header.Satellite;
    gpst = header.GPSTime;
catch
    id = header.Identifier;
    gpst = header.tow;
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
    if sort(PRNs) ~= unique(PRNs)
        error('Multiple instances of satellite found')
    end
    n = length(PRNs);
    satpos = zeros(3,n);
    bias = zeros(n,1);
    for j = 1:n
        [satpos(:,j), bias(j)] = getLocation(t,PRNs(j),igs);
    end
    prAdj = temp(:,pr)+bias;
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

