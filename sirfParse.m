function out = sirfParse(filename, avg)
% filename: SiRF file name
% avg: average CNR flag
% out: Output data

%% Import data
[~, name, ext] = fileparts(filename);
fprintf('Importing %s%s...', name, ext)
sirf = importData(filename);

%% Get GPS time from filename
v = datevec([name(1:6) name(8:13)], 'ddmmyyHHMMSS');
t = datetime(v, 'TimeZone', 'UTC');
[wn, tow] = utc2gps(t);

%% Read input
header = sirf.header;
id = header.Satellite;
gpst = header.GPSTime;
start = header.CNR1;
fin = header.CNR10;
data = sirf.data;

%% Remove lines using elapsed time
data(data(:,gpst)-tow<0,:) = [];

%% Filter GPS data
PRNs = unique(data(:,id));
GPS = PRNs(PRNs<64);
GLONASS = PRNs(PRNs>=64);

for i = 1:length(GLONASS)
    PRN = GLONASS(i);
    data(data(:,id)==PRN,:) = [];
end

%% Average non-zero CNRs
if avg
    data(mode(data(:,start:fin),2)==0,:) = [];
    CNRs = data(:,start:fin);
    CNRs(CNRs==0) = NaN;
    cnr = mean(CNRs,2,'omitnan');
else
    cnr = smoothCNR(data, header);
end
data(:,start:fin) = [];
data = [data cnr];
for i = 1:10
    header = rmfield(header, ['CNR' num2str(i)]);
end
header.CNR = size(data,2);

%% Round time to nearest second
data(:,gpst) = round(data(:,gpst));

%% Prepare output
out.header = header;
out.wn = wn;
out.tow = tow;
out.PRN = GPS;
out.data = data;
fprintf('Done\n')

end

