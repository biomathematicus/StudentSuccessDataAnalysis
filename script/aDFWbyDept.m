function [TeXout, T] = aDFWbyDept(varargin) % sStart sEnd sSubjectCode sInstructor sCourseNumber sGrades 
    config
    global bShowInstructor
    
    if nargin==0        
        global sStart sEnd sSubjectCode sInstructor sCourseNumber sGrades 
        l_sStart = sStart;
        l_sEnd = sEnd;
        l_sSubjectCode =sSubjectCode ;
        l_sInstructor = sInstructor;
        l_sCourseNumber = sCourseNumber;
        l_sGrades = sGrades;
    else
        l_sStart = varargin{1};
        l_sEnd = varargin{2};
        l_sSubjectCode =varargin{3} ;
        l_sInstructor = varargin{4};
        l_sCourseNumber = varargin{5};
        l_sGrades = varargin{6};
    end
    l_sSubjectCode = funSanitizeString(l_sSubjectCode);
    global person
    nFontSize = 10;
    TeXout = ''; T={};

    sFileName = ['aDFWbyDept-' ... 
                strrep(l_sStart,'.','-') '-' ...
                strrep(l_sEnd,'.','-') '-' ...
                strrep(l_sSubjectCode,'%','All')  '-' ...
                strrep(l_sInstructor,'%','All')  '-' ...
                strrep(l_sCourseNumber,'%','All')  '-' ...
                strrep(l_sGrades,'%','All') ...
                ];
    sSQL = ['exec spDFWByFaculty ''' l_sStart ''',''' l_sEnd ''',''' l_sSubjectCode ''',''' l_sInstructor ''',''' l_sCourseNumber ''',''' funInSQLTable(l_sGrades) ''''];
    [o, ~] = funSaveMAT(sFileName, sSQL, 'C');
     
    if isempty(o) 
        return
    end
    data = cell2mat(o(1:end,2:5));
    data(:,3) = data(:,1)./data(:,2);
    idx = data(:,1) == 0 | data(:,3) == 1; % Remove courses with no target grades (most of records) or 100% rate for the grade (few outliers)
    data(idx,:) = [];
    if isempty(data)
        return
    end
    
    fig = funNewFig();
    if bShowInstructor
        person = o(1:end,1);    % Instructor name
    else
        person = o(1:end,end);    % Instructor code
    end
    person(idx) = []; 
    if isempty(person) 
        return
    end    
    x = data(:,4);          % Course level
    y = data(:,2);          % Total Number of  Students
    z = data(:,3);          % DFW Rate
    r = data(:,1);          % Number of DFW
    %varNames = {'Students','DFWRate','DFWStudents'};

    p = unique(person);        
    for i=1:length(p)
        idx = ismember(person,p{i});
        xx(i) = mean(x(idx));
        yy(i) = sum(y(idx));
        zz(i) = sum( z(idx) .* y(idx) ) / sum(y(idx));
        rr(i) = sum(r(idx));
    end
    person = p; 
    x = xx'; y = yy'; z = zz'; r = rr';

    c = randi(10, size(x)); % Color of bubbles, to make individual marks more visible

    global aDFWbyInstDATA; aDFWbyInstDATA = [x y z]; 
    h = scatter3(x,y,z,r*10,c, 'filled', 'MarkerEdgeColor', 'k');
    %zlim([0 1]);
    title([l_sSubjectCode ' -  Radius ~ # of ' l_sGrades ]);
    text(x, y, z, person,'fontsize',nFontSize);
    xlabel('Course level');
    ylabel('Total Number of  Students');
    zlabel(['Rate of grades ' l_sGrades]); %ztickformat(ax, 'percentage'); 
    
    view(0,0)
    TeXout = funPrintImage(fig,['figDFWByDeptLevel-' l_sSubjectCode],12);
    %funTexReport(TeXout,'a');
    
    view(90,0)
    s = funPrintImage(fig,['figDFWByDeptNumStud-' l_sSubjectCode],12);
    %funTexReport(TeXout,'a');
    TeXout = [TeXout newline newline '\\newpage' newline newline s]; 
    
    
    T = table(y, z,'RowNames',person,'VariableNames',{'NumberOfStudents','FailRate'});
    sortrows(T,2,'descend')
    %funTexReport(newline, 'a',T);  

    % The following is to respond to user's selection of instructor
    %oDCM = datacursormode(fig); 
    %set(oDCM,'UpdateFcn',@aDFWbyInstCURSOR1)
end
