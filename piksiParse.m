function [out, clk] = piksiParse(datafile)
% input: Piksi file name
% out: Output data

%% Import data
[~, name, ext] = fileparts(datafile);
disp(['Importing ' name ext '...'])
piksi = importData(datafile);

%% Read input
header = piksi.header;
id = header.Identifier;
data = piksi.data;

%% Unit correction
data(:,header.tow) = data(:,header.tow)/1000;
data(:,id) = data(:,id)+1;

% %% Split data by PRN
% vec = data(:,id) + 1;
% PRNs = unique(vec);
% SVN.PRN = PRNs;
% 
% for i = 1:length(PRNs)
%     PRN = PRNs(i);
%     str = ['PRN' num2str(PRN)];
%     SVN.(str) = data(vec==PRN,:);
% end
% 
% %% Check locks
% for i = 1:length(PRNs)
%     PRN = PRNs(i);
%     lock_i = data(vec==PRN,lock);
%     if any(lock_i ~= mode(lock_i))
%         disp(['Lock lost for PRN ' num2str(PRN)])
%     end
%     
% end

%% Prepare output
out.header = header;
out.wn = data(1,header.wn);
out.tow = data(1,header.tow);
out.PRN = unique(data(:,id));
out.data = data;
fields = fieldnames(header);
clk.header = rmfield(header, fields(3:end));
clk.data = unique(data(:,1:2),'rows');
disp('Finished parsing Piksi file')

end

