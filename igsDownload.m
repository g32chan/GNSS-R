function igsFile = igsDownload(wn, tow)
% wn: GPS week number
% tow: time of week [sec]
% igsFile: IGS file name

today = datetime('now', 'TimeZone', 'UTC');
utc = gps2utc(wn, tow);
d = today - utc;
d.Format = 'd';
if d < 21
    ftype = 'igr';
else
    ftype = 'igs';
end

day = floor(tow/86400);
name = [ftype num2str(wn) num2str(day) '.sp3'];
ext = '.Z';

link = ['https://igscb.jpl.nasa.gov/igscb/product/' num2str(wn) '/' name ext];
fname = [pwd '\' name ext];
if exist(name, 'file') == 2
    disp('IGS file already exists')
    igsFile = name;
    return
end

if exist(fname, 'file') == 2
    status = system(['7z e ' fname]);
    if status ~= 0
        error('Error decompressing')
    end
    if exist(name, 'file') == 2
        igsFile = name;
        delete(fname);
        return
    end
end

fh = fopen(fname, 'wb');
jurl = java.net.URL(link);
is = jurl.openStream;
disp('Downloading IGS file...')
while true
    b = is.read;
    if b == -1
        break
    end
    fwrite(fh, b, 'uint8');
end
is.close;
fclose(fh);
disp('Download complete')

status = system(['7z e ' fname]);
if status ~= 0
    error('Error decompressing')
end
if exist(name, 'file') == 2
    igsFile = name;
    delete(fname);
else
    error('File not found');
end

end

