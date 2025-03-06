function [o, sDataFile] = funSaveMAT(sFileName, sSQL, sType)
    sDataFile = ['..' filesep 'data' filesep sFileName '.mat']; 
    if exist(sDataFile,'file') 
        load(sDataFile);
    else
        try
            switch sType
                case 'C' % CELL
                    o = funQuery2Cell(sSQL); 
                case 'M' % MATRIX
                    o = funQuery2Matrix(sSQL); 
            end
            save(sDataFile, 'o');
        catch e
            disp(e)
        end
    end
end

