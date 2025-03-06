function [conn,r] = funDataReader(sSQL)
% This function executes a data reader using the .NET framework. It has
% been decoupled from other data functions in order to centralize the data
% access methods, e.g. OLEDB, SQlCLient, OracleClient, etc. 
% Author: Juan B. Gutierrez - juan.gutierrez3@utsa.edu
% Date: 09/2019
    connString = funConnString('SQLServer');
    NET.addAssembly('System.Data');
    import System.Data.*
    
    %conn = Odbc.OdbcConnection(connString);
    %q = Odbc.OdbcCommand(sSQL, conn);
    %conn.Open();
    
    %conn = SqlClient.SqlConnection(connString);
    %q = SqlClient.SqlCommand(sSQL, conn);
    %conn.Open();

    %conn = OracleClient.OracleConnection(connString);
    %q = OracleClient.OracleCommand(sSQL, conn);
    %conn.Open();

    % OLEDB is slightly slower than other methods,m but it works with ALL
    % data providers.
    conn =  OleDb.OleDbConnection(connString);
    q = OleDb.OleDbCommand(sSQL, conn);
    q.CommandTimeout = 300; 
    conn.Open();
    %tic
    try
        r = q.ExecuteReader();
    catch er
        toc
        disp er
        error('')
    end
    %toc
end

