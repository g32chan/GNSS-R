function out = importData(filename)
% filename: Name of file to import
% data: Parsed data output

fid = fopen(filename, 'r');
if fid == -1
    error('Cannot open file')
end

header = fgetl(fid);
header = strsplit(header, ',');
for i = 1:length(header)
    temp = strsplit(header{i}, '(');
    header(i) = strtrim(temp(1));
end
header = matlab.lang.makeValidName(header);

i = 1;
while ~feof(fid)
    currLine = fgetl(fid);
    F = strsplit(currLine, ',');
    
    for j = 1:length(F)
        obs(i,j) = str2double(F{j});
    end
    
    i = i + 1;
end

fclose(fid);

out.data = obs;
for i = 1:length(header)
    out.header.(header{i}) = i;
end

end

