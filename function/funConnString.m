function connString = funConnString(sType)
% This function generates a query string to connect to the ModelDB in the 
% MaHPIC project via OLEDB using the .NET System.Data namespace.  
% Author: Juan B. Gutierrez - juan.gutierrez3@utsa.edu
% Date: 09/2019
    switch sType
        case 'MySQL'
            sType = 'Driver={MySQL ODBC 5.1 Driver}';
            port = '3306';
            host = '.';
        case 'SQLServer'
            sType = 'Driver={SQL Server Native Client 11.0}';
            port = '1433';
            host = '.';
        case 'Oracle'
            sType = 'Driver={Oracle in ModelDB}';
            port = '389';
            host = '.';
    end
    Provider='SQLOLEDB';
    user = 'math';  
    password = '00#200'; 
    dbName = 'UTSA';
    connString = ['Server=' host ';Database=' dbName ...
                  ';Trusted_Connection=Yes' ...
                  ';Provider=' Provider...
                  ';Port=' port ';']; % sType ';Option=3;' ...
                  %'Connection Timeout=0;' ...
                  %'Connect Timeout=0;'];
                  %';Uid=' user ';Pwd=' password ...
end
