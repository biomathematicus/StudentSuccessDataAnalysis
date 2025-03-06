function cData = funExplorer(sExpID, sClass, sType, plotFigure)
% This function goes through all datasets available in MaHPIC and plots variables
% Author: Juan B. Gutierrez - juan@math.uga.edu
% Author: Patrick Breen
% Date: 11/2013
% Example: scpExplorer('2', 'plasma', 'nhp_plasma_biotin_mb', true)
%
% Copyright Juan B Gutierrez 2013
% Based on work by Juan B. Gutierrez (c) 2010
% This code can be reused as long as proper credits appear. You can use
% this code but you cannot present it as your own work. If substantial
% modifications occur, the following disclosure must appear:
% "Based on work by Juan B. Gutierrez (c) 2010"
addpath('..\IO');
addpath('..\SQL');
addpath('..\function');

%the explorer does not currently work on functional genomics data
if strcmp(sClass, 'FXGN') == 1
    return
end

%get unique subjects, per experiment, per class, per type
cSubject = classMahpicDatabase().getSubjects(sExpID, sClass, sType);
nNumSubjects = size(cSubject, 1); %number of distinct subjects
cSeries = cell(nNumSubjects, 1);  %the names of the subject will be added to the plot as a series legend
%get distinct time points per experiment, per class, per type, for all
%subjects
cDistinctTimes = classMahpicDatabase().getDistinctTimes(sExpID, sClass, sType);
tDistinctTimes = cell2table(cDistinctTimes);               %distinct times converted to a dataset with name 'date'
tDistinctTimes.Properties.VariableNames = {'date'};

%iterate over each subject, (subjects will be columns in our cell
%array, and series in our plots)
for k=1:nNumSubjects
    nSubject = cell2mat(cSubject(k, 1)); %@nSubject is the id of the subject
    result = classMahpicDatabase().getValues(sExpID, sClass, sType, nSubject); %1 )result is the cell of values for the given subject
    sNamesResult = {'date', char(strcat('var', num2str(k)))};       %2) name the result the 'date'
    tResult = cell2table(result);                                   %3) convert the result to a table and set name
    tResult.Properties.VariableNames = sNamesResult;                %
    tDistinctTimes = outerjoin(tDistinctTimes, tResult, 'Type', ... %4) merge the result with results for other subjects,
        'left', 'MergeKeys', true);                                     % using a left join to pad missing values
    cSeries(k:end,1) = cSubject(k,2);                               % append to the series
end
cData = table2cell(tDistinctTimes);                                %convert table back to a cell

if plotFigure
    figure()
    x = datenum(cData(1:end,1));
    y = cell2mat(cData(1:end,2:end));
    plot(x,y)
    datetick('x', 6)
    xlabel('time')
    ylabel('value')
    t = title(strcat('Class: ', sClass, ' type: ', sType));
    set(t,'Interpreter','none');
end

return
