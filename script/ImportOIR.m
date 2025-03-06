%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function o = ImportOIR()
    addpath(['..' filesep 'function']); 
    % Open file 
    %if exist('File.mat') == 0
        %sFile = '../../OIR/201908048-TutorAllocationModel.txt';
        tic
        sFile = '../../OIR/201910053-TutorAllocationModel_20191111.txt';
        fid = fopen(sFile, 'r');
        % Read line of data and load it into a vector named "row"
        tline = fgetl(fid);
        row = regexp(tline, '\|', 'split'); 
        % Load comma separated values into the structure "header"
        OIR.Header = row; 
        OIR.Size = zeros(size(row));
        % Parse and read rest of file
        i = 1;
        while(~feof(fid))        
            tline = fgetl(fid);
            if ischar(tline)
                % Read line of data and load it into a vector named "row"
                row = regexp(tline, '\|', 'split');            
                rowSize = size(row);

%                 for j=1:size(row,2)
%                     s = row{j};
%                     s = strrep(s,'"','');
%                     if OIR.Size(j) < size(s,2)
%                         OIR.Size(j) = size(s,2); 
%                     end
%                 end

                sSQL = [' USE MATH      ' ... 
                'INSERT INTO dbo.OIR ' ... 
                '(' ...
                'IDENTIFIER' ... 
                ',ETHNICITY' ... 
                ',GENDER' ... 
                ',FA_APPLIED' ... 
                ',AGI' ... 
                ',PELLSTATUS' ... 
                ',FIRSTGENERATIONSTATUS' ... 
                ',ZIPCODE' ... 
                ',STUDENTTYPE' ... 
                ',CAP' ... 
                ',FIRSTTERMDESC' ... 
                ',FIRSTTERMCODE' ... 
                ',SAT_COMPOSITE' ... 
                ',SAT_MATH' ... 
                ',SAT_ERW' ... 
                ',SAT_COMPOSITE_OLD' ... 
                ',SAT_MATH_OLD' ... 
                ',SAT_VERBAL_OLD' ... 
                ',SAT_WRITING_OLD' ... 
                ',SATOLD_WCR' ... 
                ',SAT_COMPOSITE_CONVERTED' ... 
                ',SAT_MATH_CONVERTED' ... 
                ',SAT_WCR_CONVERTED' ... 
                ',ACT_COMPOSITE' ... 
                ',ACT_MATH' ... 
                ',ACT_ENG' ... 
                ',ACT_READ' ... 
                ',ACT_ER' ... 
                ',ACT_SCIREAS' ... 
                ',ACT_WRITE' ... 
                ',ACT_COMPOSITE_CONVERTED' ... 
                ',ACT_MATH_CONVERTED' ... 
                ',ACT_ER_CONVERTED' ... 
                ',HIGHEST_SATACT_COMPOSITE' ... 
                ',HIGHEST_SATACT_MATH' ... 
                ',HIGHEST_SATACT_ERW' ... 
                ',HIGHSCHOOLNAME' ... 
                ',HIGHSCHOOLCITY' ... 
                ',HIGHSCHOOLSTATE' ... 
                ',HIGHSCHOOLZIP' ... 
                ',MAT1073_AP_GRDE' ... 
                ',MAT1073_DUAL_GRDE' ... 
                ',MAT1073_CLEP_GRDE' ... 
                ',MAT1093_AP_GRDE' ... 
                ',MAT1093_DUAL_GRDE' ... 
                ',MAT1093_CLEP_GRDE' ... 
                ',MAT1214_AP_GRDE' ... 
                ',MAT1214_DUAL_GRDE' ... 
                ',MAT1214_CLEP_GRDE' ... 
                ',MAT1224_AP_GRDE' ... 
                ',MAT1224_DUAL_GRDE' ... 
                ',MAT1224_CLEP_GRDE' ... 
                ',CURRENTTERM' ... 
                ',CURRENTTERMCODE' ... 
                ',PROGRAM' ... 
                ',COLLEGE' ... 
                ',DEPARTMENT' ... 
                ',SHRTCKN_SUBJ_CODE' ... 
                ',CT_SUBJDESC' ... 
                ',CT_SUBJECT' ... 
                ',SHRTCKN_SEQ_NUMB' ... 
                ',SHRTCKN_CRN' ... 
                ',SHRTCKN_CRSE_TITLE' ... 
                ',PRIMARY_INSTRUCTOR_ID' ... 
                ',INSTRUCTORNAME' ... 
                ',SHRTCKG_CREDIT_HOURS' ... 
                ',MIDTERM_GRADE' ... 
                ',SHRTCKG_GRDE_CODE_FINAL' ... 
                ',SHRGRDE_QUALITY_POINTS' ... 
                ',SHRGRDE_GPA_IND' ...
                ',SHRTCKN_REPEAT_COURSE_IND' ... 
                ',STVSCHD_DESC' ... 
                ',FIRSTGRADDATE' ... 
                ',FIRSTGRADPROGRAM' ... 
                ',FIRSTGRADCOLLEGE' ... 
                ',FIRSTGRADDEPT' ... 
                ')' ... 
                ' VALUES ' ... 
                ' ('... 
                textDatum(row{1})... 
                textDatum(row{2})... 
                textDatum(row{3})... 
                textDatum(row{4})... 
                textDatum(row{5})... 
                textDatum(row{6})... 
                textDatum(row{7})... 
                textDatum(row{8})... 
                textDatum(row{9})... 
                numberDatum(row{10})... 
                textDatum(row{11})... 
                numberDatum(row{12})... 
                numberDatum(row{13})... 
                numberDatum(row{14})... 
                numberDatum(row{15})... 
                numberDatum(row{16})... 
                numberDatum(row{17})... 
                numberDatum(row{18})... 
                numberDatum(row{19})... 
                numberDatum(row{20})... 
                numberDatum(row{21})... 
                numberDatum(row{22})... 
                numberDatum(row{23})... 
                numberDatum(row{24})... 
                numberDatum(row{25})... 
                numberDatum(row{26})... 
                numberDatum(row{27})... 
                numberDatum(row{28})... 
                numberDatum(row{29})... 
                numberDatum(row{30})... 
                numberDatum(row{31})... 
                numberDatum(row{32})... 
                numberDatum(row{33})... 
                numberDatum(row{34})... 
                numberDatum(row{35})... 
                numberDatum(row{36})... 
                textDatum(row{37})... 
                textDatum(row{38})... 
                textDatum(row{39})... 
                textDatum(row{40})... 
                textDatum(row{41})... 
                textDatum(row{42})... 
                textDatum(row{43})... 
                textDatum(row{44})... 
                textDatum(row{45})... 
                textDatum(row{46})... 
                textDatum(row{47})... 
                textDatum(row{48})... 
                textDatum(row{49})... 
                textDatum(row{50})... 
                textDatum(row{51})... 
                textDatum(row{52})... 
                textDatum(row{53})... 
                numberDatum(row{54})... 
                textDatum(row{55})... 
                textDatum(row{56})... 
                textDatum(row{57})... 
                textDatum(row{58})... 
                textDatum(row{59})... 
                textDatum(row{60})... 
                textDatum(row{61})... 
                numberDatum(row{62})... 
                textDatum(row{63})... 
                textDatum(row{64})... 
                textDatum(row{65})... 
                numberDatum(row{66})... 
                textDatum(row{67})... 
                textDatum(row{68})... 
                numberDatum(row{69})... 
                textDatum(row{70})... 
                textDatum(row{71})... 
                textDatum(row{72})... 
                textDatum(row{73})... 
                textDatum(row{74})... 
                textDatum(row{75})... 
                textDatum(row{76},'')... 
                ')'];
                %textDatum(row{40},'') ... 

                % Increment row counter for the structure OIR
                disp(i)
                try
                    [conn,r] = funDataReader(sSQL);
                catch err
                    disp(err)
                end
                i = i + 1;
            else
                break;
            end
        end
        fclose(fid);
        toc
    %    save('File', '')
    %else
    %    load('File', '')
    %end 
end

function out = textDatum(s,varargin)
    switch nargin
        case 1
            sComma = ',';
        case 2
            sComma = '';
    end
    t = strrep(s,'"','');
    t = strrep(t,'''','''''');
    if size(s) > 0
        out = [''''  t  '''' sComma];
    else
        out = ['NULL' sComma];
    end
end

function out = numberDatum(n)
    if size(n) > 0
        out = [strrep(n,'"','') ','];
    else
        out = 'NULL,';
    end
end
