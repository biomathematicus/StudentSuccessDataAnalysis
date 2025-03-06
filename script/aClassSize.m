function TeXout = aClassSize(sStart, sEnd, sSubject, sCourseNumber)
    %example:  aClassSize('2014.66', '2019.33',  '%','%')
    config
    TeXout = '';
    nMax = 1/5;
    if strcmp(sSubject,'%')
        xMax = 500;
    else 
        xMax = 200;
    end    

    sSQL = ['exec ClassRoomSize ' sStart ',' sEnd];
    sFileName = funSanitizeString(['aClassSize-' sStart '-' sEnd]);
    [o, sDataFile] = funSaveMAT(sFileName, sSQL, 'C');
    data = cell2mat(o(:,5:6));
    %s = ['select distinct [SHRTCKN_SUBJ_CODE] from OIR order by [SHRTCKN_SUBJ_CODE]'];
    s = ['select [SHRTCKN_SUBJ_CODE], count(distinct IDENTIFIER) '...
            ' from OIR '...
            ' where CURRENTTERM>=''' sStart '''' ...
            ' and CURRENTTERM<=''' sEnd '''' ...
            ' and [SHRTCKN_SUBJ_CODE] like ''' sSubject '''' ...
            ' and [CT_SUBJECT] like ''' sCourseNumber '''' ...
            ' group by [SHRTCKN_SUBJ_CODE] ' ...
            ' order by  [SHRTCKN_SUBJ_CODE]'];
    o1 = funQuery2Cell(s); 
    fig = funNewFig();
    
    if strcmp(sSubject,'%')
        for i=1:length(o1)
            nMax = o1{i,2} / max(cell2mat(o1(:,2)));
            disp(o1{i,1})
            idx = ismember(o(:,2),o1{i,1});
            x = data(idx,:);
            try
                if length(x) > 5            
                    TeXout = PlotCS(x, funSanitizeString(o1{i,1}),fig, nMax, xMax); hold on;
                end
            catch e
                disp(e)
            end
        end
        hold off
        title('')
        funPrintImage(fig,'figClassSizeUTSA',12)
    else
        if strcmp(sCourseNumber,'%')
            idx = ismember(o(:,2),sSubject);
            x = data(idx,:);
            idx = x(:,1) > 10; 
            x = x(idx,:);
            try
                if length(x) > 3            
                    TeXout = PlotCS(x, funSanitizeString(sSubject),fig,nMax, xMax);
                end
            catch e
                disp(e)
            end
        else
            idxSubject = ismember(o(:,2),sSubject);
            idxNumber = ismember(o(:,3),sCourseNumber);
            x = data(idxSubject & idxNumber,:);
            idx = x(:,1) > 10; 
            x = x(idx,:);
            try
                if length(x) > 3            
                    TeXout = PlotCS(x, funSanitizeString([sSubject sCourseNumber]),fig,nMax, xMax);
                end
            catch e
                disp(e)
            end
        end
    end

    return
    fig = figure();     clf; 
    set(fig,'WindowStyle','docked');
    % Math courses
    subplot(1,2,1)
    idx = ismember(o(:,2),'MAT');
    x = data(idx,:);
    PlotCS(x, 'Math',fig,nMax, xMax)
    % Non-Math courses
    subplot(1,2,2)
    idx =ismember(o(:,2),{'BIO','CHE','PHY','GEO','ES','CS','BME','CME','CE','EE','ME'});
    x = data(idx,:);
    PlotCS(x, 'Non-Math COS+COE',fig,nMax, xMax)
    funPrintImage(fig,'figClassSizeCOSCOE',12)
end

function TeXOut = PlotCS(x,sTitle,fig,nMax, xMax)
    m = max(x(:,1));
    nClassSizeIncrement = 5;
    if xMax ~=500
        xMax = 1.1*m; 
    end
    xMin=0; yMin = 0; yMax = 4;

    %Find duplicate entries and average associated values
    [C,~,idx] = unique(x(:,1),'stable');
    % The following shoudl work, but it doesn't...
    %val = accumarray(idx,x(:,2),[],@mean); % Ran out of time to figure it out.
    % ... therefore I had to do the inefficient loop: 
    for i=1:length(C)
        idx = x(:,1) == C(i);
        val(i,1) = mean(x(idx,2));
    end
    X = [C val];
    X = sortrows(X);
    
    % Now find average GPA for each range of classroom size
    y=[];
    for i = nClassSizeIncrement:nClassSizeIncrement:m+nClassSizeIncrement
        idx = X(:,1) > i-nClassSizeIncrement & X(:,1) <= i;
        y(i,1) = i;
        y(i,2) = mean(X(idx,2));
        y(i,3) = (sum(idx))^2;
    end
    y(y(:,1)==0,:) = [];
    y(isnan(y(:,2)),:) = [];

    % With the average of each classroom size, add interpolations to
    % smotoh average representation
    X = 10:nClassSizeIncrement:500; % Minimum class size is 10, increment of 5 for interpolation
    Y = interp1(y(:,1),y(:,2),X); 
    idx = find(~isnan(Y)); %Y(end)> xMax-50; 
    X = X(idx); Y = Y(idx); 
    
    
    try
        Y = funHodrickPrescott(Y,10000); 
        %yHP = (y(:,1) \ y(:,2)) * y(:,1);
    catch e
        disp(e);
    end
    colormap summer;
    c = randi(10, size(y)); % Color of bubbles, to make individual marks more visible
    scatter(y(:,1),y(:,2),y(:,3)*10,c, 'filled', 'MarkerEdgeColor', 'k');
    hold on;
    if strcmp('MAT',sTitle)==1
        sColor = 'r';
    else
        sColor = 'b';
    end
    
    p = X(end); q = Y(end);
    grid on
    text(p, q, sTitle);    
    plot(X,Y, sColor, 'LineWidth', 10*nMax);
    hold off;
    axis([xMin xMax yMin yMax]);
    title(sTitle); 
    xlabel('# of Students');
    ylabel('GPA');
    legend('Raw Data', 'Hodrick-Prescott Filter','Location','SouthEast');
    TeXOut = funPrintImage(fig,funSanitizeString(['figClassSize-' sTitle]),12);
end

function [s] = funHodrickPrescott(y,w)
    if size(y,1)<size(y,2)
       y=y';
    end
    t=size(y,1);
    a=6*w+1;
    b=-4*w;
    c=w;
    d=[c,b,a];
    d=ones(t,1)*d;
    m=diag(d(:,3))+diag(d(1:t-1,2),1)+diag(d(1:t-1,2),-1);
    m=m+diag(d(1:t-2,1),2)+diag(d(1:t-2,1),-2);
    %
    m(1,1)=1+w;       m(1,2)=-2*w;
    m(2,1)=-2*w;      m(2,2)=5*w+1;
    m(t-1,t-1)=5*w+1; m(t-1,t)=-2*w;
    m(t,t-1)=-2*w;    m(t,t)=1+w;
    %
    s = m\y;
end