function TeXout = aUTSAStat(sCollege, sDepartment, sStart, sEnd)
    config
    TeXout = ''; %'\\section{General Statistics}';
    data = [];
    nColYear = 3;
    nColCH = 4;
    
    s = strrep([sCollege '-' sDepartment],' ','');
%     if strcmp(sDepartment,'%')==0
%         s = strrep(sDepartment,' ','');
%     else
%         s = strrep(sCollege,' ','');
%     end
    if strcmp(sCollege,'%') & strcmp(sDepartment,'%')
        s = '%-%';
        sTitle = funSanitizeString(['All Students ' sStart '/' sEnd]);
    else
        sTitle = funSanitizeString([strrep(sDepartment,'%',sCollege) ' ' sStart '/' sEnd]);
    end
    sFileName = funSanitizeString(['aUTSAStat-' s '-' sStart '-' sEnd]);
    if 1==1
        sSQL = ['exec spStudents ''' sCollege...
                ''',''' sDepartment ''',' sStart ',' sEnd  ];
        [o,sDataFile] = funSaveMAT(sFileName, sSQL, 'C');

        if isempty(o) 
            return
        end

        mYear  = unique(cell2mat(o(:,nColYear)));

        % First point of control: Time series of students
        m  = cell2mat(o(:,nColYear));  m1 = unique(cell2mat(o(:,nColYear)));      
        m = m-floor(m);         m1 = m1-floor(m1);
        %  Peculiarity due to floating point. Epsilon is defined in config
        idxSpring = m < epsilon;    
        idxSpring1 = m1 < epsilon;
        idxSummer = m < 0.33+epsilon & m > 0.33-epsilon;
        idxSummer1 = m1 < 0.33+epsilon & m1 > 0.33-epsilon;
        idxFall = m < 0.66+epsilon & m > 0.66-epsilon;
        idxFall1 = m1 < 0.66+epsilon & m1 > 0.66-epsilon;

        mSummer = []; mFall = []; mSpring = [];    
        for i=1:length(mYear)
            idxYear = cell2mat(o(:,nColYear)) == mYear(i); 
            dummy = o(idxSummer & idxYear,nColCH:end);
            if ~isempty(dummy) 
                temp = sum(cell2mat(dummy),1);
                mSummer = [mSummer; temp];
            end
            dummy = o(idxFall & idxYear,nColCH:end);
            if ~isempty(dummy) 
                 temp = sum(cell2mat(dummy),1);
                 mFall = [mFall; temp];
            end
            dummy = o(idxSpring & idxYear,nColCH:end);
            if ~isempty(dummy) 
                temp = sum(cell2mat(dummy),1);
                mSpring = [mSpring; temp];
            end
            data = [data; mYear(i) temp];
        end

        % Consolidate by year, adding all colleges
        if strcmp(sCollege,'%') && strcmp(sDepartment,'%')
            idxSpring = idxSpring1;
            idxSummer = idxSummer1;
            idxFall = idxFall1;
        end    

        % Total admissions per year
        fig = funNewFig();
        hold on
        try
            plot(mYear(idxSpring), mSpring(:,3), '^-','LineWidth', 3)
            plot(mYear(idxSummer), mSummer(:,3), 's-','LineWidth', 3)
            plot(mYear(idxFall), mFall(:,3),'o-','LineWidth', 3)
            legend('Spring', 'Summer', 'Fall','Location', 'Best')
            title(sTitle);
            ax = gca;
            ax.YAxis.Exponent = 0;
            s = funPrintImage(fig,[sFileName '-A'],12);
            TeXout = [TeXout newline newline s];
        catch er
            disp(er)
        end
    end
    
    % Calculate total graduates per year
    fig = funNewFig();
    sSQL = ['exec spGraduation ''' sCollege...
                ''',''' sDepartment ''',' sStart ',' sEnd];
    [o,sDataFile] = funSaveMAT([sFileName '-E1'], sSQL, 'C');
    if ~isempty(o) 
        datag = cell2mat([o(:,1), o(:,4)]); 
        t = unique(datag(:,1));
        x = []; 
        for i = 1:size(t,1)
            idx = datag(:,1) == t(i);
            x(i) = sum(datag(idx,2));
        end

        sSQL = ['exec spRecruitment ''' sCollege...
                    ''',''' sDepartment ''',' sStart ',' sEnd];
        [o,sDataFile] = funSaveMAT([sFileName '-E2'], sSQL, 'C');
        if ~isempty(o) 
            datar = cell2mat([o(:,1), o(:,4)]); 
            t1 = unique(datar(:,1));
            x1 = [];
            for i = 1:size(t1,1)
                idx = floor(datar(:,1)) == t1(i);
                x1(i) = sum(datar(idx,2));
            end
            plot(t1(1:end-1),x1(1:end-1),'r',t,x,'b', 'LineWidth', 3);
            ax = gca;
            ax.XLim = [str2num(sStart) str2num(sEnd)];
            legend('Admitted','Graduated','Location', 'NorthWest');
            title(sTitle);
            s = funPrintImage(fig,[sFileName '-E'],12);
            TeXout = [TeXout newline newline '\\newpage' newline newline s];
        end
    end

    
    % proportion of first-generation students
    fig = funNewFig();
    bar(data(:,1), data(:,4:7)./data(:,3), 'stacked');
    legend('New Not First-Gen','New First-Gen', 'Transfer Not First-Gen', 'Transfer First Gen','Location', 'Best');
    title(sTitle);
    s = funPrintImage(fig,[sFileName '-B'],12);
    TeXout = [TeXout newline newline '\\newpage' newline newline s];
    
    % ratio female/male
    fig = funNewFig();
    b = bar(data(:,1), data(:,8:9)./(data(:,8)+data(:,9)), 'stacked','FaceColor','flat');
    b.CData
    legend('Female','Male','Location', 'Best');
    title(sTitle);
    s = funPrintImage(fig,[sFileName '-C'],12);
    TeXout = [TeXout newline newline '\\newpage' newline newline s];
    
    fig = funNewFig();
    bar(data(:,1), data(:,10:11)./(data(:,10)+data(:,11)), 'stacked');
    legend('Pell','No Pell','Location', 'Best');
    title(sTitle);
    s = funPrintImage(fig,[sFileName '-D'],12);
    TeXout = [TeXout newline newline '\\newpage' newline newline s];    

    % Student demographics
    sSQL = ['exec spDemographics ''' sCollege...
                ''',''' sDepartment ''',' sStart ',' sEnd];
    [o,sDataFile] = funSaveMAT([sFileName '-F'], sSQL, 'C');
    if ~isempty(o)
        idxGrad = ismember(cell2mat(o(:,5)), 1); 
        cEth = unique(o(:,1));
        for i = 1:size(cEth,1)
           idx1 = ismember(o(:,1),cEth(i)) & ~idxGrad;
           idx2 = ismember(o(:,1),cEth(i)) & idxGrad;
           cEth{i,2} = sum(cell2mat(o(idx1,4))); % Admitted
           cEth{i,3} = sum(cell2mat(o(idx2,4))); % Graduated
        end   
        fig = funNewFig();
        subplot(2,1,1)
        pie(cell2mat(cEth(:,2)), cEth(:,1));
        title('Admitted')
        subplot(2,1,2)
        pie(cell2mat(cEth(:,3)), cEth(:,1));
        title('Graduated')
        s = funPrintImage(fig,[sFileName '-F'],12);
        TeXout = [TeXout newline newline '\\newpage' newline newline s];
        %---------
        fig = funNewFig();
        d = cell2mat(cEth(:,3)) ./ cell2mat(cEth(:,2)); 
        [~,idx] = sort(d);
        c = categorical(cEth(idx,1),'Ordinal',true);
        bar(c,d(idx));
        title('Proportion of Graduates by Ethnicity');
        s = funPrintImage(fig,[sFileName '-G'],12);
        %TeXout = [TeXout newline newline '\\newpage \\section{Department of Mathematics}' newline newline];
        TeXout = [TeXout newline newline '\\newpage' newline newline s];
    end

end