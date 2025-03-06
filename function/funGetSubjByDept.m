function out = funGetSubjByDept(sCollege)
    out = funQuery2Cell(['select department from dept where college  = ''' sCollege ...
        ''' and department <> ''NA'' group by department order by department']); 
end
