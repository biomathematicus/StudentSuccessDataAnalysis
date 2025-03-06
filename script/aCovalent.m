function aDonorAcceptor()
    config
    sFileName = 'aCovalent_MAT.mat';
    tic
    if exist(sFileName,'file') 
        load(sFileName);
    else
        sSQL = 'exec spCovalent ''MAT'', 2014.0, 2020 ';
        o = funQuery2Cell(sSQL); 
        save(sFileName, 'o')
    end
    toc

    cDonor = unique(o(:,2));
    mDonorGPA = [];
    cAcceptor = unique(o(:,3));
    m = [];
    for i = 1:length(cDonor)
        idxDonor = ismember(o(:,2),cDonor(i)); 
        n = sum(idxDonor); 
        m(i) = n;
        if n>2
            [n, GPA, p, h] = ComputeGPA(o(idxDonor,4:5));
            mDonorGPA(i,1) = m(i);
            mDonorGPA(i,2) = n;
            mDonorGPA(i,3) = GPA(1);
            mDonorGPA(i,4) = GPA(2);
            mDonorGPA(i,5) = GPA(2)/GPA(1);
            mDonorGPA(i,6) = h;
            mDonorGPA(i,7) = p;
        end
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

     T = table(mDonorGPA(:,1),mDonorGPA(:,2),mDonorGPA(:,3),mDonorGPA(:,4),mDonorGPA(:,5),mDonorGPA(:,6),mDonorGPA(:,7),...
                'RowNames',cDonor,...
                'VariableNames',{'Students', 'PropMath', 'MathGPA', 'NonMathGPA','RatioGPA','RejectH0','p_value'}); 
     sortrows(T,7,'ascend')
end

function [n, GPA, p, h] = ComputeGPA(o)
    idx = ones(size(o,1),1);
    for i=1:size(o,1)
        if isempty(o{i,1})
            idx(i)=0;
        end
        if isempty(o{i,2})
            idx(i)=0;
        end        
    end
    n = sum(idx)/size(o,1);
    idx = logical(idx);
    gpa = cell2mat(o(idx,:));
    GPA = mean(gpa, 1);
    [p,h] = ranksum(gpa(:,1),gpa(:,2));
end