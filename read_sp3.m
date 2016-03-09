function sp3 = read_sp3(filename)
% Modified from read_sp3.m by David Wiese (2006)
% filename: Name of SP3 file
% sp3: Parsed data output

fid = fopen(filename);
if fid == -1
    error('Cannot open file')
end

for i = 1:23
    currLine = fgetl(fid);
    if i == 3
        currLine = currLine(2:length(currLine));
        F = sscanf(currLine, '%u');
        numSat = F(1);
    end
end

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

sp3.data = sp3_obs_all;
sp3.col.wn = 1;
sp3.col.tow = 2;
sp3.col.prn = 3;
sp3.col.X = 4;
sp3.col.Y = 5;
sp3.col.Z = 6;
sp3.col.B = 7;

end

