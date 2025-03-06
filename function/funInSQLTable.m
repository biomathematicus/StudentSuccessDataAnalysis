function s = funInSQLTable(sValues)
    a = regexp(sValues,',','split');
    sComma = '';
    s = ''
    for i = 1:length(a)
        s = [s sComma '(''''' a{i} ''''')'];
        sComma = ',';
    end
    s = ['select x from (values ' s ') temp(x)'];
    s = ['create table temp (a varchar(100)); insert into temp ' s];
end

