function out = funQuery2Matrix(sSQL)
% This function converts a generic query into a MATLAB native matrix. It is
% assumed that the query only contains numerical values or dates. All other
% data types will cause this function to fail. 
% Author: Juan B. Gutierrez - juan.gutierrez3@utsa.edu
% Date: 09/2019

    [conn,r] = funDataReader(sSQL);
    nCol = cast(r.FieldCount,'double');
    out=[]; % Initialize out variable
    while r.Read()
        out(end+1,:)=zeros(1,nCol); % Increase size of out at every loop
        for i=1:nCol
            try
                % It is assumed that the data in the record set is numeric
                d = r.Item(i-1);
                out(end,i) = cast(d,'double');
            catch err
                % If an error occurs, then the only allowed alternative is
                % to have a DATE type. This program does not support any
                % other data types (e.g. strings are not allowed). 
                out(end,i) = datenum(char(r.Item(i-1).ToString));
            end
        end
    end
    % Close connection
    r.Close()
    conn.Close()
end
