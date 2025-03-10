function out = funGetInstBySubject(sSubject, sCourseNumber)
    global bShowInstructor
    if bShowInstructor
        sSQL = ['select distinct INSTRUCTORNAME from OIR where [SHRTCKN_SUBJ_CODE] = ''' ... 
                sSubject ''' and [CT_SUBJECT] = ''' sCourseNumber ''' group by INSTRUCTORNAME order by INSTRUCTORNAME ']; 
    else
        sSQL = ['select distinct PRIMARY_INSTRUCTOR_ID from OIR where [SHRTCKN_SUBJ_CODE] = ''' ... 
                sSubject ''' and [CT_SUBJECT] = ''' sCourseNumber ''' group by PRIMARY_INSTRUCTOR_ID order by PRIMARY_INSTRUCTOR_ID ']; 
    end
    out = funQuery2Cell(sSQL); 

    if ~isempty(out)
        % If there is an empty intructor ID, the first row must be eliminated
        if isempty(out{1,1})
            out(1,:) = [];
        end
    end
end

