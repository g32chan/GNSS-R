function out = sirfParse(datafile)
% filename: SiRF file name
% out: Output data

%% Import data
[~, name, ext] = fileparts(datafile);
disp(['Importing ' name ext '...'])
sirf = importData(datafile);

%% Get GPS time from filename
v = datevec([name(9:14) name(16:21)], 'ddmmyyHHMMSS');
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
disp('Filtering data...')
data(data(:,gpst)-tow<0,:) = [];

%% Average non-zero CNRs
data(mode(data(:,start:fin),2)==0,:) = [];
CNRs = data(:,start:fin);
CNRs(CNRs==0) = NaN;
cnr = mean(CNRs,2,'omitnan');
data(:,start:fin) = [];
data = [data cnr];
for i = 1:10
    header = rmfield(header, ['CNR' num2str(i)]);
end
header.CNR = size(data,2);

%% Filter GPS data
PRNs = unique(data(:,id));
GPS = PRNs(PRNs<64);
GLONASS = PRNs(PRNs>=64);

for i = 1:length(GLONASS)
    PRN = GLONASS(i);
    data(data(:,id)==PRN,:) = [];
end

%% Prepare output
out.header = header;
out.wn = wn;
out.tow = tow;
out.PRN = GPS;
out.data = data;
disp('Finished parsing SiRF file')

end

