function out = funGetSubjectByDept(sDept)
    sSQL = ['select [subject]  from dept where [DEPARTMENT] = ''' sDept ''' group by [subject] order by [subject]'];
    out = funQuery2Cell(sSQL); 
end
