function out = funQuery2Cell(sSQL)
% This function converts a generic query into a MATLAB cell array. 
% The query can contain characters and numbers. 
% Author: Juan B. Gutierrez - juan.gutierrez3@utsa.edu
% Date: 09/2019

    [conn,r] = funDataReader(sSQL);
    nCol = cast(r.FieldCount,'double');
    out={}; % Initialize out variable
    while r.Read()
        out(end+1,:)=cell(1,nCol); % Increase size of out at every loop
        for i=1:nCol
            try
                % It is assumed that the data in the record set is numeric
                out(end,i) = {cast(r.Item(i-1),'double')};
            catch err
                % If an error occurs, then try to cast to char type.  
                out(end,i) = {char(r.Item(i-1).ToString)};
            end
        end
    end
    % Close connection
    r.Close()
    conn.Close()
end
