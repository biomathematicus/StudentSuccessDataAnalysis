function sOut = funDate2String(sDate)
%FUNDATE2STRING Converts decimal semester to descriptor
%   Assumption: x.0 = Spring, x.33 = Summer, x.66 = Fall    
    fDate = str2num(sDate);
    sOut = '';
    x = int8((fDate - floor(fDate))*100);
    switch x
        case 0
            sOut = 'Spring';
        case 33.
            sOut = 'Summer';
        case 66.
            sOut = 'Fall';
    end
    sOut = [sOut ' ' num2str(floor(fDate))];
end

