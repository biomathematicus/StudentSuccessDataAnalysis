function TeXout = aDFWbyCourse(varargin) 
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
    global person
    l_sSubjectCode = funSanitizeString(l_sSubjectCode);
    l_person = person;
    nFontSize = 10;
    TeXout = '';

    sFileName = ['aDFWbyCourse-' ... 
                strrep(l_sStart,'.','-') '-' ...
                strrep(l_sEnd,'.','-') '-' ...
                strrep(l_sSubjectCode,'%','All')  '-' ...
                strrep(l_sInstructor,'%','All')  '-' ...
                strrep(l_sCourseNumber,'%','All')  '-' ...
                strrep(l_sGrades,'%','All') ...
                ];
    sSQL = ['exec spDFWByFaculty ' ...
                l_sStart ',' ...
                l_sEnd ',''' ... 
                l_sSubjectCode ''',''' ...
                strrep(l_sInstructor,'''','''''') ''',''' ...
                l_sCourseNumber ''',''' ...
                funInSQLTable(l_sGrades) ''''];
	[o, sDataFile] = funSaveMAT(sFileName, sSQL, 'C');
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
    ax = axes;
    if bShowInstructor
        l_person = o(1:end,1);    % Instructor name
    else
        l_person = o(1:end,end);    % Instructor ID
    end
    l_person(idx) = []; 
    semester = o(1:end,6);    % Semester
    semester(idx) = [];
    course = o(1:end,7);    % Course name
    course(idx) = [];    
    for i = 1:length(course)
        semester{i} = [semester{i} '-' course{i}]; 
    end
    x = data(:,4);          % Course level
    y = data(:,2);          % Total Number of  Students
    z = data(:,3);          % DFW Rate
    r = data(:,1);          % Number of DFW

    c = randi(10, size(x)); % Color of bubbles, to make individual marks more visible

    h = scatter3(x,y,z,r*10,c, 'filled', 'MarkerEdgeColor', 'k');
    zlim([0 1]);
    if strcmp(l_sInstructor,'%')==1
        s = course{1};
        c = l_person;
    else
        s = l_sInstructor;
        c = semester;
    end
    title([s ' -  Radius ~ # of ' l_sGrades ]);
    %text(x(I), y(I), z(I), course(I),'fontsize',nFontSize);
    text(x, y, z, c,'fontsize',nFontSize);
    xlabel('Course level');
    ylabel('Total Number of  Students');
    zlabel(['Rate of grades ' l_sGrades]); %ztickformat(ax, 'percentage'); 
    view(90,0)
    try
        TeXout = funPrintImage(fig,['figDFWByFaculty-' funSanitizeString(s)] ,12);
    catch er
        disp(er)
    end
end
