%% Global Variables
clear; clc; config;
%dos(['cd ..' filesep 'report & clean.bat '])
%dos(['..' filesep 'script' filesep 'clean.bat '])
global sStart sEnd sSubjectCode sCollege sCourseNumber sGrades sInstructor bShowInstructor

% GRaduattion rates: Use FIRSTTERMCODE, and separate students by credit
% hours, where > 12 = full-time. Remove part-time (few students)
% look at: COM 1053 - Biz Comm

tic
%% Configuration

%set(0,'DefaultFigureVisible','on');
%mPeriods = {'2018.66', '2019.33'; 
%            '2014.66', '2019.33'; 
%            '2009.66','2019.33'};
mPeriods = {'2014.66', '2019.66'};
sGrades = 'D,D+,D-,F,IN,NC,NR,W';
sStart = '2014.66'; sEnd = '2019.66';
bShowInstructor = true; 

ww = 1; % select case for result presentation
switch ww
    case 1
      bOneFilePerDepartment = false;
      bReportCourses = true; 
    case 2
      bOneFilePerDepartment = true;
      bReportCourses = true; 
    case 3
      bOneFilePerDepartment = false;
      bReportCourses = false; 
end

%% University-wide report, before going college by college. 
funTexReport('','w', [], '../report/DataIntroReport.tex'); 

TeXout = aUTSAStat('%', '%', sStart, sEnd); 
s = ['\\subsection{UTSA General Statistics ' sStart '-' sEnd '}'];
funTexReport(TeXout,'w', [], '../report/DataIntroReport.tex'); 
close all

TeXout = aUTSAAllMath(sStart, sEnd); 
s = ['\\subsection{Math and COS-Specific Statistics ' sStart '-' sEnd '}'];
funTexReport(TeXout,'a', [], '../report/DataIntroReport.tex'); 
close all

T = aOddsRatio(sStart, sEnd);
s = ['\\subsection{Odds Ratio Sorted by Students Served ' sStart '-' sEnd '}' newline newline 'To interpret the odds ratio (OD), keep in mind that an $OD > 1$ is bad for students, and an $OD < 1$ is beneficial. If the column $H_0 = 1$, then the null hypothesis is rejected, i.e. there is a true effect; however, the $p$-value has not been corrected for multiple hypothesis (e.g. Benjamini-Hochberg, Bonferroni, etc.), and should be used only as a comparative indicator' newline newline];
funTexReport(s,'a', [], '../report/DataIntroReport.tex'); 
funTexReport('','a', sortrows(T,9, 'descend'), '../report/DataIntroReport.tex'); 
s = ['\\subsection{Odds Ratio Sorted by Alphabetical Order ' sStart '-' sEnd '}' newline newline 'To interpret the odds ratio (OD), keep in mind that an $OD > 1$ is bad for students, and an $OD < 1$ is beneficial. If the column $H_0 = 1$, then the null hypothesis is rejected, i.e. there is a true effect; however, the $p$-value has not been corrected for multiple hypothesis (e.g. Benjamini-Hochberg, Bonferroni, etc.), and should be used only as a comparative indicator' newline newline];
funTexReport(s,'a', [], '../report/DataIntroReport.tex'); 
funTexReport('','a', T, '../report/DataIntroReport.tex'); 

%sDept = '%'; 
%[T,s] = aDonorAcceptor(sStart, sEnd, sCollege, sDept);
%funTexReport('\\subsection{Donor and Acceptor Majors}','a', [], '../report/DataIntroReport.tex'); 
%funTexReport(s,'a', [], '../report/DataIntroReport.tex'); 
%funTexReport('','a', sortrows(T,7, 'ascend'), '../report/DataIntroReport.tex'); 

%% Stats by subject
cCollege = funGetColleges();
cCollege = {'Sciences'};
%funTexReport(['\\chapter{Data ' sStart '-' sEnd '} \\clearpage' newline],'a')
for i = 1:length(cCollege)
    disp(cCollege{i})
    %funTexReport('','w', [], '../report/DataIntroReport.tex')
    if bReportCourses
        sReportFile = ['../report/' funSanitizeString(cCollege{i}) '.tex']; 
    else
        sReportFile = ['../report/ABRIDGED-' funSanitizeString(cCollege{i}) '.tex']; 
    end
    funTexReport('','w', [], sReportFile); % Initialize file
    funTexReport(['\\clearpage \\chapter{College: ' strrep(cCollege{i},'&','And') '}' newline '\\clearpage' newline], ...
        'a', [], sReportFile)
    TeXout = aUTSAStat(cCollege{i}, '%', sStart, sEnd);
    funTexReport([TeXout newline newline],'a', [], sReportFile);
    close all
    cDept = funGetDeptByCollege(cCollege{i});
    %cDept = {'Mathematics'};
    %cDept = {'General (COS)'};
    for j = 1:length(cDept)
        disp(cDept{j})
        if bOneFilePerDepartment
            sReportFile = ['../report/' funSanitizeString([cCollege{i} ' - ' cDept{j}]) '.tex']; 
            funTexReport('','w', [], sReportFile); % Initialize file
        end
        %================================================
        funTexReport(['\\clearpage \\section{Department: ' strrep(cDept{j},'&','And') '}' newline],'a', [], sReportFile);
        disp(['    Department   : ' cDept{j}]);
        TeXout = aUTSAStat(cCollege{i}, cDept{j}, sStart, sEnd);
        funTexReport(TeXout,'a', [], sReportFile);            
        close all
        %================================================
        [T,TeXout] = aDonorAcceptor(sStart, sEnd, 'MAT', cDept{j});
        funTexReport(['\\clearpage \\subsection{Donors and Acceptors}' newline],'a', [], sReportFile);
        funTexReport(TeXout,'a', [], sReportFile);
        %================================================
        [TeXout, cT] = aRevenue(cCollege{i}, cDept{j});
        if ~isempty(cT)
            funTexReport(['\\clearpage \\subsection{Credit Hours by Course}' newline],'a', [], sReportFile);
            funTexReport(TeXout,'a', [], sReportFile);
            funTexReport(['\\clearpage \\subsubsection{Total Credit Hours and Revenue}' newline],'a', [], sReportFile);
            s = ['Revenue estimation does not include learnign resource fee (except for mathematics). ' ...
                'It is calculated for each course in the last year on the table. ' ...
                'This computational exercise is intended for illustration purposes only, '...
                'and should not be considered an accurate or complete calculation.  '...
                'Revenue is calculated according to the formula '...
                '\\[ Revenue = 0.56 \\cdot Weight \\cdot (\\$69.6 \\cdot COR +  \\$73.93 \\cdot COI ),  \\] '...
                'where COR = College of Record, and COI = College of Instruction. '...
                newline];
            T = cT{1};
            funTexReport(s,'a', [], sReportFile);
            funTexReport('','a', T, sReportFile);
            n = funGetNmbrStdByDept(cDept{j}, sStart, sEnd);
            funTexReport(['Number of students served by department:' num2str(n)],'a', [], sReportFile);
            funTexReport(['\\clearpage \\subsubsection{College of Record Credit Hours}' newline],'a', [], sReportFile);
            funTexReport('','a', cT{2}, sReportFile);
            funTexReport(['\\clearpage \\subsubsection{College of Instruction Credit Hours}' newline],'a', [], sReportFile);
            funTexReport('','a', cT{3}, sReportFile);
        end
        %================================================
        cSubject = funGetSubjectByDept(cDept{j});
        if bReportCourses
            %cSubject = {'MAT'};
            for k = 1:size(cSubject,1)
                [TeXout, T] = aDFWbyDept(sStart, sEnd, cSubject{k}, '%', '%', sGrades ); 
                close all
                if ~isempty(TeXout)
                    funTexReport(['\\clearpage \\subsection{Course Code: ' funSanitizeString(cSubject{k}) '}' newline],'a', [], sReportFile)
                    disp(['        Subject  : ' cSubject{k}])
                    funTexReport(TeXout,'a', [], sReportFile);
                    funTexReport([newline '\\clearpage  \\subsubsection{Instructor''s  Rate of ' sGrades '}' newline],'a', [], sReportFile);
                    funTexReport('', 'a', sortrows(T,2, 'descend'), sReportFile); 
                end
                %================================================
                cInst = funGetInstBySubject(cSubject{k});
                for n=1:size(cInst,1)
                    % sStart sEnd sSubjectCode sInstructor sCourseNumber sGrades 
                    [TeXout] = aDFWbyCourse(sStart, sEnd, cSubject{k}, cInst{n}, '%', sGrades );  
                    close all
                    if ~isempty(TeXout)
                        funTexReport(['\\clearpage \\subsubsection{' cInst{n} '}' newline],'a', [], sReportFile)
                        disp(['        Instructor: ' cInst{n}])
                        funTexReport(TeXout,'a', [], sReportFile);
                    end
                end
                %================================================
                cCourseNmbr = funGetCourseNmbrBySubject(cSubject{k});
                for n=1:size(cCourseNmbr,1)
                    s = funSanitizeString([cCourseNmbr{n,1} cCourseNmbr{n,2} ' - ' cCourseNmbr{n,3}]);
                    cInst = funGetInstByCourse(cSubject{k}, cCourseNmbr{n,2});
                    % sStart sEnd sSubjectCode sInstructor sCourseNumber sGrades 
                    [TeXout] = aDFWbyCourse(sStart, sEnd, cSubject{k}, '%', cCourseNmbr{n,2}, sGrades );  
                    close all
                    if ~isempty(TeXout)
                        funTexReport(['\\clearpage \\subsubsection{' s '}' newline],'a', [], sReportFile)
                        disp(['        Course: ' s])
                        funTexReport(TeXout,'a', [], sReportFile);
                    end
                    %================================================
                    TeXout = aClassSize(sStart, sEnd, cSubject{k}, cCourseNmbr{n,2});  
                    close all
                    if ~isempty(TeXout)
                        funTexReport(['\\clearpage \\subsubsection{' cCourseNmbr{n,1} cCourseNmbr{n,2} ' - Classroom Size}' newline],'a', [], sReportFile)
                        disp(['        Course: ' s])
                        funTexReport(TeXout,'a', [], sReportFile);
                    end
                end
            end
        end
        % Now write and compile full report for this particular department
        if bOneFilePerDepartment
            sReportFile = ['..' filesep 'report' filesep 'REPORT - ' funSanitizeString([cCollege{i} ' - ' cDept{j}]) '.tex']; 
            sReportFile = strrep(sReportFile, ' ', ''); 
            funTexReport('\\documentclass[letterpaper,12pt]{report}','w', [], sReportFile); 
            funTexReport(['\\newcommand{\\StartDate}{' funDate2String(sStart) '}'], 'a', [], sReportFile); 
            funTexReport(['\\newcommand{\\EndDate}{' funDate2String(sEnd) '}'], 'a', [], sReportFile); 
            funTexReport(['\\newcommand{\\College}{College: ' funSanitizeString(cCollege{i}) '}'], 'a', [], sReportFile); 
            funTexReport(['\\newcommand{\\Grades}{Grades: ' funSanitizeString(sGrades) '}'], 'a', [], sReportFile); 
            funTexReport(['\\newcommand{\\Department}{Department: ' funSanitizeString(cDept{j}) '}'], 'a', [], sReportFile); 
            funTexReport('\\include{0config}', 'a', [], sReportFile); 
            funTexReport('\\begin{document}','a', [], sReportFile); 
            funTexReport('\\include{0FrontMatter}', 'a', [], sReportFile); 
            funTexReport('\\include{1Introduction}', 'a', [], sReportFile); 
            funTexReport(['\\input{' funSanitizeString(cCollege{i}) '}'],'a', [], sReportFile); 
            funTexReport(['\\input{' funSanitizeString([cCollege{i} ' - ' cDept{j}]) '}'],'a', [], sReportFile); 
            funTexReport('\\end{document}','a', [], sReportFile); 
            dos(['cd ..' filesep 'report & pdflatex ' sReportFile(11:end)])
            % The second compilation is to guarantee that table of content is displayed
            dos(['cd ..' filesep 'report & pdflatex ' sReportFile(11:end)])
        end
    end
    % Now write and compile full report for this particular department
    if ~bOneFilePerDepartment
        if bReportCourses
            sReportFile = ['..' filesep 'report' filesep 'REPORT-' funSanitizeString(cCollege{i}) '.tex']; 
        else
            sReportFile = ['..' filesep 'report' filesep 'REPORT-ABRIDGED-' funSanitizeString(cCollege{i}) '.tex']; 
        end
        sReportFile = strrep(sReportFile, ' ', ''); 
        funTexReport('\\documentclass[letterpaper,12pt]{report}','w', [], sReportFile); 
        funTexReport(['\\newcommand{\\StartDate}{' funDate2String(sStart) '}'], 'a', [], sReportFile); 
        funTexReport(['\\newcommand{\\EndDate}{' funDate2String(sEnd) '}'], 'a', [], sReportFile); 
        funTexReport(['\\newcommand{\\College}{College: ' funSanitizeString(cCollege{i}) '}'], 'a', [], sReportFile); 
        funTexReport(['\\newcommand{\\Grades}{Grades: ' funSanitizeString(sGrades) '}'], 'a', [], sReportFile); 
        funTexReport('\\newcommand{\\Department}{}', 'a', [], sReportFile); 
        funTexReport('\\include{0config}', 'a', [], sReportFile); 
        funTexReport('\\begin{document}','a', [], sReportFile); 
        funTexReport('\\include{0FrontMatter}', 'a', [], sReportFile); 
        funTexReport('\\include{1Introduction}', 'a', [], sReportFile); 
        if bReportCourses
            funTexReport(['\\input{' funSanitizeString(cCollege{i}) '}'],'a', [], sReportFile); 
        else
            funTexReport(['\\input{ABRIDGED-' funSanitizeString(cCollege{i}) '}'],'a', [], sReportFile); 
        end
        funTexReport('\\end{document}','a', [], sReportFile); 
        dos(['cd ..' filesep 'report & pdflatex ' sReportFile(11:end)])
        % The second compilation is to guarantee that table of content is displayed
        dos(['cd ..' filesep 'report & pdflatex ' sReportFile(11:end)])
    end        
end
    

toc

return


%%   This code is to explore individual cases on demand
colormap summer
sStart = '2014.66';
sEnd = '2019.33';
sSubjectCode = 'MAT';
sCollege = '%';
sCourseNumber = '%';    
sGrades = 'F,W'; % 'A,A+,A-,B,B+,B-,C,C+,C-,D,D+,D-,F,IN,NC,NR'; % 
sInstructor = '%';
aDFWbyDept
%aDFWbyCourse
