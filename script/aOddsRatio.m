function T = aOddsRatio(sStart, sEnd)    
    
    o1 = funQuery2Cell('select distinct SHRTCKN_SUBJ_CODE from oir order by SHRTCKN_SUBJ_CODE'); 
    H=[]; P=H; OR=H; A=H; B=H; C=H; D=H; 
    for i = 1:length(o1)
        o1{i} = strrep(o1{i},'&','and');
        sFileName = ['aOddsRatio-' o1{i} '-' ...
                    strrep(sStart,'.','-') '-' ...
                    strrep(sEnd,'.','-')];
        disp(sFileName)
        sSQL = ['exec spOddsRatio ''' o1{i} ''',' sStart, ',' sEnd];
        %o2 = funQuery2Cell(['exec spOddsRatio4thYear [' o1{i} ']']); 
        [o2,sDataFile] = funSaveMAT(sFileName, sSQL, 'C');
        % a =   Number of exposed cases: 
        %       All students who took X classes and have no 4000 courses
        a = o2{1,2};
        % b =   Number of exposed non-cases: 
        %       Students who took X classes and have 4000 courses
        b = o2{2,2};
        % c =   Number of unexposed cases: 
        %       Students who never took X class and do not have 4000 courses 
        c = o2{3,2};
        % d =   Number of unexposed non-cases: 
        %       Students who never took X class and have 4000 courses 
        d = o2{4,2};
        t = a+b+c+d;
        %     pie([c d a b], ...
        %         {...
        %         ['No-Math No-4K (' num2str(floor(100*c/t)) '%)'],...
        %         ['No-Math 4K (' num2str(ceil(100*d/t)) '%)'],...
        %         ['Math No-4K (' num2str(floor(100*a/t)) '%)'],...
        %         ['Math 4K (' num2str(ceil(100*b/t)) '%)'],...
        %         });
        %     title('4th-Year Courses After 4 Years');

        x = table([a;c],[b;d],'VariableNames',{'No4K','Yes4K'},'RowNames',{o1{i},['No-' o1{i}]});
        %disp(x)
        [h,p] = fishertest(x);
        or = (a/c) / (b/d);
        H = [H; h]; 
        P = [P; p]; 
        OR = [OR; or]; 
        A=[A; floor(a)]; 
        B=[B; floor(b)]; 
        C=[C; floor(c)]; 
        D=[D; floor(d)];
    end
    T = table(OR,H,P,A,B,C,D,zeros(size(D)),zeros(size(D)), ...
        'RowNames',o1,...
        'VariableNames',{'OR','H_0', 'p',...
        'a', 'b', 'c', 'd', 'PercNO4K', 'PercStd'});
    x = table2array([T(:,1) T(:,4:7)]);
    x(:,6) = (x(:,2))./(x(:,2)+(x(:,3)+(x(:,4)+(x(:,5)))));
    %[h, crit_p, adj_p]=funFDRBH(X,q,'pdep','yes');
    x(:,7) = (x(:,2)+x(:,3))./(x(:,2)+(x(:,3)+(x(:,4)+(x(:,5)))));
    T(:,8) = array2table(x(:,6)); 
    T(:,9) = array2table(x(:,7));
    %save(sFileName, 'T')
    % Remove subjects studied by less than 1% of all students
    %idx = T.PercStd < 0.01;
    %T(idx,:) = [];
    return
    disp('Mean Odds Ratio')
    disp(mean(T.OddsRatio))

    return
    idx = ismember(T.Row,{'MAT','BIO','CHE','AST','PHY','CS','ES','GEO'});
    COS = T(idx,:); 
    sortrows(COS,9, 'descend')

    [h, crit_p, adj_p]=funFDRBH(table2array(T(:,3)),0.001,'pdep','yes');
    idx = T.p_value < crit_p ;
    out = T(idx,:);
    out.A = []; out.B = []; out.C = []; out.D = []; 
    sortrows(out,1, 'descend');
end