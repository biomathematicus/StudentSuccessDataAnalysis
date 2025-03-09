function connString = funConnString(sType)
% This function generates a query string to connect to the database
% via OLEDB using the .NET System.Data namespace.  
% Access is designed for local trusted authentication, i.e. login and
% password are not required int he pipeline. Standard local configuration
% must be addressed to gurantee authentication. 
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
    dbName = 'UTSA';
    connString = ['Server=' host ';Database=' dbName ...
                  ';Trusted_Connection=Yes' ...
                  ';Provider=' Provider...
                  ';Port=' port ';']; 
end
