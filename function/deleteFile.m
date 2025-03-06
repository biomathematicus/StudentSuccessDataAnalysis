function deleteFile(sFileName)
    try
        dos(['del ..\data\' sFileName '.mat'])
        disp('No error')        
    catch er
        disp('Error: ')        
        disp(er)        
    end
end

