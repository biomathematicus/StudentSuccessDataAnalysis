config
sSQL = 'exec spStudentDemographics';
sFileName = 'aStudentDemographics.mat';
tic
if exist(sFileName,'file') 
    load(sFileName);
else
    o = funQuery2Cell(sSQL); 
    save(sFileName, 'o')
end
toc
% Indices for first generation
idxFirstGen = ismember(o(:,2),'First Generation');  
idxNotFirstGen = ismember(o(:,2),'Not First Generation');  
% Indices for ethnicity
idxAA = ismember(o(:,3),'Black or African-American');  
idxPacific = ismember(o(:,3),'Native Hawaiian or Other Pacific Islander');  
idxAsia = ismember(o(:,3),'Asian');  
idxTwoOrMore = ismember(o(:,3),'Two or More Races');  
idxNR = ismember(o(:,3),'Unknown or Not Reported');  
idxInternational = ismember(o(:,3),'International');  
idxEuropean = ismember(o(:,3),'White');  
idxNativeAm = ismember(o(:,3),'American Indian or Alaskan Native');  
idxHispanic = ismember(o(:,3),'Hispanic or Latino');  
% Indices Pell status
idxPell = ismember(o(:,4),'Pell Paid');  
idxNoPell = ismember(o(:,4),'No Pell');  

SATPell = o(idxPell,6);
%S = sprintf('%s ', SATPell{:});
%SATPell = sscanf(S, '%f');
idx = SATPell==[]
SATNoPell = o(idxNoPell,6);
[h,p] = kstest(SATPell)

SATPell = cell2mat(o(1:end,2:end));
data(:,3) = data(:,1)./data(:,2);
idx = data(:,1) == 0; 
data(idx,:) = [];
idx = data(:,3) == 1; 
data(idx,:) = [];

fig = figure(1); clf
person = o(1:end,1);    % Instructor name
x = data(:,4);          % Course level
%x = floor(data(:,4)/1000); % Course level
y = data(:,2);          % Total Number of  Students
z = data(:,3);          % DFW Rate
r = data(:,1);          % Number of DFW
%varNames = {'Students','DFWRate','DFWStudents'};

[B,I] = sort(y,'descend'); 
c = randi(10, size(I)); % Color of bubbles, to make individual marks more visible


colormap summer
h = scatter3(x,y,z,data(:,1)*10,c, 'filled', 'MarkerEdgeColor', 'k');
text(x(I), y(I), z(I), person(I),'fontsize',10);
xlabel('Course level');
ylabel('Total Number of  Students');
zlabel('DFW Rate')
title('DFW By Instructor - Radius proportional to total # of DFWs');

%T = table(x(I), y(I), r(I),'RowNames',person(I),'VariableNames',varNames)
oDCM = datacursormode(fig); 
set(oDCM,'UpdateFcn',@funCursorDFWbyInst)