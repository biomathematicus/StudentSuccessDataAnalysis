config
sFileName = 'aStratified.mat';
tic
if exist(sFileName,'file') 
    load(sFileName);
else
    sSQL = 'exec spClassSize ';
    o = funQuery2Cell(sSQL); 
    save(sFileName, 'o')
end
toc
% Semesters
cSem = unique(o(:,1));
t = []; s = [];
for i = 1:length(cSem)
    idx = ismember(o(:,1),cSem(i));
    fSem = str2num(cSem{i});
    t = [t; fSem];
    s = [s;sum(cell2mat(o(idx,5)))];
end
fig = figure(); clf; 
set(fig,'WindowStyle','docked');
l = {'Fall', 'Spring', 'Summer'}
for i = 1:3
    subplot(1,3,i)
    plot(t(i:3:end), s(i:3:end));
    grid on
    title(l(i));
    axis([t(1) t(end) 0 max(s)])
end
% Courses
cCourses = unique(o(:,4));
for i = 1:length(cCourses)
    idx = ismember(o(:,4),cCourses(i));
    cCourses{i,2} = sum(cell2mat(o(idx,5))); 
    cCourses{i,3} = sum(cell2mat(o(idx,6))); 
    cCourses{i,4} = sum(cell2mat(o(idx,7))); 
    o2 = o(idx,:);
    idx = ismember(o2(:,1),'2018.66');
    cCourses{i,4} = sum(idx);
end

return
mFall = [t(1:3:end) s(1:3:end)];
mSpring = [t(2:3:end) s(2:3:end)];
mSummer = [t(3:3:end) s(3:3:end)];
plot(mFall(:,1),mFall(:,2))
B = [ones(size(t)) t]\s