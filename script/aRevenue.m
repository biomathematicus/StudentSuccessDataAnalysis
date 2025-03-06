function [TeXout, cTables] = aRevenue(sCollege, sDepartment)
    % Example: aRevenue('Sciences','Mathematics')
    config
    fRateCOR = 69.6;
    fRateCOI = 73.93;
    fLRF = 15; 
    fTaxRate = 0.44;
    TeXout = ''; cTables = {};
    
    TeXout = '';
    sFileName = funSanitizeString(['aRevenue-' sCollege '-' sDepartment]);
    sSQL = ['exec spRevenue''' sCollege ''',''' sDepartment ''''];
    [o, sDataFile] = funSaveMAT(sFileName, sSQL, 'C');
    if isempty(o)
       return 
    end
    try
        data = cell2mat(o(:,2:end)); 
        % Total credit hours 
        idx = data(:,1) == 1;
        TOTAL = data(idx,2:end);
        idTOTAL = o(idx,1);
        m = size(TOTAL,1); % Number of courses
        n = size(TOTAL,2); % Number of years of data
        % College of record credit hours
        idx = data(:,1) == 2;
        COR = data(idx,2:end);
        idCOR = o(idx,1);
        % College of instruction credit hours
        idx = data(:,1) == 3;
        COI = data(idx,2:end);
        idCOI = o(idx,1);
        % Non-linear regression for COR based
        oeTOTAL = MultipleOddExtension(TOTAL); 
        oeCOI = MultipleOddExtension(COI); 
        oeCOR = MultipleOddExtension(COR); 
    catch er
        disp(er)
    end
    % revenue for projected year
    R = {}; W = []; sR = 0;
    for i=1:m
        R{i} = 0;
        s = idTOTAL{i};
        sFileName = funSanitizeString(['aRevenue-CourseWeight-' s]);
        sSQL = ['SELECT WEIGHT FROM WEIGHT WHERE SUBJECT+CODE=''' s ''''];
        [w, sDataFile] = funSaveMAT(sFileName, sSQL, 'M');
        p = ismember(idCOR,s);
        q = ismember(idCOI,s);
        % Revenue by college of record
        if ~isempty(idCOR(p))
            R{i} = R{i} + fRateCOR * COR(p,n);
        end
        % Revenue by college of instruction
        if ~isempty(idCOI(q))
            R{i} = R{i} + fRateCOI * COI(q,n);
        end
        % Learning resource fee
        if strcmp(sDepartment, 'Mathematics') ==  1
            R{i} = R{i} + fLRF * TOTAL(i, end);
        end
        % Apply course weight
        if isempty(w)
            w = 1;
        end
        W(i) = w;
        R{i} = w * R{i};
        % Apply tax
        R{i} = (1-fTaxRate) * R{i}; 
        sR = sR + R{i};
    end
    
    fig = funNewFig();
    p = 5; q = ceil(m/p); % this is to create a matrix of plots
    for i=1:m
        subplot(p,q,i)
        plot(1:n,TOTAL(i,:),'b', 1:n+2, oeTOTAL(i,1:n+2), 'r');
        title(idTOTAL{i}); 
        grid on;
        %set(gca,'visible', 'off');
    end
    TeXout = funPrintImage(fig,[sFileName '-Projections'],12);
    %TeXout = [TeXout newline newline s];
    R = R'; W = W';
    % Format revenue as currency
    j = java.text.NumberFormat.getCurrencyInstance();
    for i=1:m
        R(i) = j.format(R{i});
        R{i} = ['\' R{i}];
    end
    R(end+1) = j.format(sR);
    R{end} = ['\' R{end}];
    W(end+1) = sum(W);
    idTOTAL{end+1} = 'TOTAL';

    TOTAL = [TOTAL; sum(TOTAL)];
    % Table for total number of credit hours
    tTOTAL = table(TOTAL(:,1),TOTAL(:,2),TOTAL(:,3),TOTAL(:,4),TOTAL(:,5),W,R,  ...
        'RowNames',idTOTAL(:,1), ...
        'VariableNames',{'Y1415','Y1516','Y1617','Y1718','Y1819','Weight','RevenueY1819'});
    
    % Table for college of record credit hours
    tCOR = table(COR(:,1),COR(:,2),COR(:,3),COR(:,4),COR(:,5),  ...
        'RowNames',idCOR(:,1), ...
        'VariableNames',{'Y1415','Y1516','Y1617','Y1718','Y1819'});
    tCOR = [tCOR; {sum(COR(:,1)), sum(COR(:,2)), sum(COR(:,3)), sum(COR(:,4)), sum(COR(:,5))}];
    tCOR.Row(end) = {'TOTAL'}; 
    
    % Table for college of record credit hours
    tCOI = table(COI(:,1),COI(:,2),COI(:,3),COI(:,4),COI(:,5),  ...
        'RowNames',idCOI(:,1), ...
        'VariableNames',{'Y1415','Y1516','Y1617','Y1718','Y1819'});
    tCOI = [tCOI; {sum(COI(:,1)), sum(COI(:,2)), sum(COI(:,3)), sum(COI(:,4)), sum(COI(:,5))}];
    tCOI.Row(end) = {'TOTAL'}; 
   
    cTables = {tTOTAL, tCOR, tCOI};
    
    sFileName = funSanitizeString(['REPORT-CreditHours-' sCollege '-' sDepartment]);
    sFileName = ['..' filesep 'report' filesep sFileName '.xlsx'];
    writetable(tTOTAL,sFileName,'Sheet', 'TOTAL','WriteRowNames',true);
    writetable(tCOR,sFileName,'Sheet', 'COR','WriteRowNames',true);
    writetable(tCOI,sFileName,'Sheet', 'COI','WriteRowNames',true);
end

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function f = MultipleOddExtension(A)
    %This function creates an odd extension of matrix A     
    % Vectorizaiton gave me a bit of trouble... no time to fix it now
    % Doing a simple and inefficient for loop
    
    n = size(A,2);
    f = [];
    for i=1:size(A,1)
        y = A(i,:);
        g = -flipud(y') + 2*y(end);
        h = funHodrickPrescott([y,g'],10); h = h'; 
        f = [f; h];        
    end
end
