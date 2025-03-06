function [T,TeXOut] = aDonorAcceptor(sStart, sEnd, sSubject, sDept)
    %example: aDonorAcceptor('2014.66', '2019.66', 'MAT', '%')
    config
    global oDA
    TeXOut = ''; T = {};
    %sStart = '2014.66';
    %sEnd = '2019.33';
    %sSubject = 'AIS';
    %sDept = 'Biology';
    
    sFileName = funSanitizeString(['aDonorAcceptor-'  sDept '-' sStart '-' sEnd '.mat']);    
    sSQL = ['exec spDonorAcceptor ''' sSubject ''',' sStart, ',' sEnd];

    if isempty(oDA)
        [o,sDataFile] = funSaveMAT(sFileName, sSQL, 'C');
        oDA = o;
    else 
        o = oDA;
    end


    cDonor = unique(o(:,2));
    mDonorGPA = [];
    cAcceptor = unique(o(:,3));
    m = [];

    nDeptDonor = 0; nDeptAcceptor = 0;
    for i = 1:length(cDonor)
        idxDonor = ismember(o(:,2),cDonor(i)); 
        if strcmp(sDept,cDonor(i))==1
            nDeptDonor = i;
        end
        for j = 1:length(cAcceptor)
            idxAcceptor = ismember(o(:,3),cAcceptor(j));
            if strcmp(sDept,cAcceptor(j))==1
                nDeptAcceptor = j;
            end
            n = sum(idxDonor & idxAcceptor);
            m(i,j) = n;
        end
        [n, GPA, p, h] = ComputeGPA(o(idxDonor,4:5));
        mDonorGPA(i,1) = sum(m(i,:));
        mDonorGPA(i,2) = n;
        mDonorGPA(i,3) = GPA(1);
        mDonorGPA(i,4) = GPA(2);
        mDonorGPA(i,5) = GPA(2)/GPA(1);
        mDonorGPA(i,6) = h;
        mDonorGPA(i,7) = p;
    end
    % Correct for empty majors
    idx = mDonorGPA(:,1) == 0; 
    mDonorGPA(idx,:) = []; 
    cDonor(idx) = [];
    % Correct by false discovery rate
    q = 0.001;
    [h crit_p adj_p]=funFDRBH(mDonorGPA(:,7),q);
    mDonorGPA(:,7) = adj_p;
    % Correct H0
    idx = mDonorGPA(:,7) < q;
    mDonorGPA(:,6) = 0;
    mDonorGPA(idx,6) = 1; 
     
    p = sum(m,2);
    [mDonor,idxDonor] = sort(p);

    p = sum(m,1);
    [mAcceptor,idxAcceptor] = sort(p,'descend');
    
    % Show how the time played is distrubuted among gamers and parts of day.
    if  nDeptDonor > 0
        n = m(nDeptDonor,:);
        idx = n>0;
        n = n(idx);
        p = cDonor(nDeptDonor);
        q = cAcceptor(idx);
        [~,idx] = sort(n);
        fig = funNewFig();
        alluvialflow([n(idx); zeros(size(n))], {p{1},' '}, q, [p ' as a Donor. N=' num2str(sum(n))]);
        TeXOut = funPrintImage(fig,['figDonorAcceptor-' funSanitizeString(sDept) '-donor'],14);
        n = m(:,nDeptAcceptor);
        idx = n>0;
        n = n(idx);
        p = cDonor(idx);
        q = cAcceptor(nDeptAcceptor);
        [~,idx] = sort(n);
        fig = funNewFig();
        alluvialflow([n(idx), zeros(size(n))] ,  p, {q{1}, ' '}, [q ' as an Acceptor. N=' num2str(sum(n))]);
        s = funPrintImage(fig,['figDonorAcceptor-' funSanitizeString(sDept) '-acceptor'],14);
        TeXOut = [TeXOut newline '\\clearpage ' newline s newline];
    else
        fig = funNewFig('Landscape');
        alluvialflow(m(idxDonor,idxAcceptor), cDonor(idxDonor), cAcceptor(idxAcceptor), 'Donor and Acceptor Majors');
        TeXOut = funPrintImage(fig,'figDonorAcceptor',14);
    end

    if strcmp(sDept,cDonor(i))==0
        T = table(mDonorGPA(:,1),mDonorGPA(:,2),mDonorGPA(:,3),mDonorGPA(:,4),mDonorGPA(:,5),mDonorGPA(:,6),mDonorGPA(:,7),...
                    'RowNames',cDonor,...
                    'VariableNames',{'Students', 'PropMath', 'MathGPA', 'NonMathGPA','Ratio','RejectH0','p_value'}); 
        sortrows(T,7,'ascend')
        funTexReport(newline, 'a',T);
    end
end

function [n, GPA, p, h] = ComputeGPA(o)
    idx = ones(size(o,1),1);
    for i=1:size(o,1)
        if length(o{i,1})==0
            idx(i)=0;
        end
    end
    n = sum(idx)/size(o,1);
    idx = logical(idx);
    try 
        gpa = cell2mat(o(idx,:));
    catch er
        disp(er)
    end
    GPA = mean(gpa, 1);
    [p,h] = ranksum(gpa(:,1),gpa(:,2));
end