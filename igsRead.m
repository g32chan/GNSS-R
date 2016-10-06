function igs = igsRead(filename)
% Modified from read_sp3.m by David Wiese (2006)
% filename: Name of SP3 file
% sp3: Parsed data output

%% Check file
fid = fopen(filename);
if fid == -1
    error('Cannot open file')
end

%% Read header
for i = 1:23
    currLine = fgetl(fid);
    if i == 3
        currLine = currLine(2:length(currLine));
        F = sscanf(currLine, '%u');
        numSat = F(1);
    end
end

%% Read data
fprintf('Importing IGS data...')
eof = 0;
i = 0;
while eof ~= 1
    currLine = currLine(2:length(currLine));
    F = sscanf(currLine, '%f');
    [wn,tow] = utc2gps(datetime(F(1),F(2),F(3),F(4),F(5),F(6),'TimeZone','UTC'),0);

    for n = 1:numSat
        currLine = fgetl(fid);
        currLine = currLine(3:length(currLine));
        F = sscanf(currLine, '%f');
        sp3_obs_all(i+n,:) = [wn tow F(1) F(2) F(3) F(4) F(5)];
    end

    currLine = fgetl(fid);
    if strfind(currLine, 'EOF')
        eof = 1;
    end

    i = i + n;
end         

fclose(fid);

%% Prepare output
igs.data = sp3_obs_all;
igs.col.wn = 1;
igs.col.tow = 2;
igs.col.prn = 3;
igs.col.X = 4;
igs.col.Y = 5;
igs.col.Z = 6;
igs.col.B = 7;
fprintf('Done\n')

end

