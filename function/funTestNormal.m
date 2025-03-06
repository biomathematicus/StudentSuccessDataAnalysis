function [Result Est1 Est2]=funTestNormal(H1,H2)

% function to calculate the normality test of two populations
% Result = P value test Normality
% Est1 = Descriptive statistics of the first population
% Est2 = Descriptive statistics of the scond population
Result=[];
idxNaN = isnan(H1);H1(idxNaN)=[];
idxNaN = isnan(H2);H2(idxNaN)=[];
    if (size(H1,1)<4 || size(H2,1)<4)
        if (size(H1,1)==0 || size(H2,1)==0)
            Result=NaN;
            h1=0;h2=0;
        else
        h1=1;h2=1;
        end
    else
        h1 = adtest (H1);
        h2 = adtest (H2);
    end
    if (h1==1 || h2==1);
        p = ranksum(H1,H2); %test Wilcoxon rank sum test Mann Whitney 
        Result=p ;
    else 
        [h p]=ttest2(H1,H2);
        Result=p;
    end 
    
    Est1=funCalculateDescrStats(H1);
    Est2=funCalculateDescrStats(H2);
end