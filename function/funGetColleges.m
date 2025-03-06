function out = funGetColleges()
    sSQL = ['select distinct college from dept ' ...
            ' where college <> ''NA'' ' ...
            ' and college <> ''Office of Undergraduate Studies'' ' ...
            ' order by college'];
    out = funQuery2Cell(sSQL); 
end

