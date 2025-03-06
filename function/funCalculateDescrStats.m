function [Result Mg]=funCalculateDescrStats(Var)

%Result [Mean- Median- Sd- Min-Max- ICS- ICI- N Q1 Q3]
%Mg - Mean Geometric
    idxNaN = isnan(Var);
    a=sum(idxNaN);b=size(Var,1);
    Var(idxNaN)=[];
    if (a==b)
        Result=[0 0 0 0 0 0 0 0 0 0];
        Mg=0;
    else
        Mean=mean(Var);

        Ds=std(Var);
        Min=min(Var);
        Max=max(Var);
        IC(1)=Mean+1.96*(Ds/sqrt(size(Var,1)));
        IC(2)=Mean-1.96*(Ds/sqrt(size(Var,1))); 
        N=size(Var,1);
        Me=median(Var);
%         Mg=prod(Var)^(1/size(Var,1));
        idx=Var>0;Var1=Var(idx);
        Mg=geomean(Var1);
        Q1= median(Var(find(Var<median(Var)))); 
        Q3=median(Var(find(Var>median(Var))));
        Result=[ Mean Me Ds Min Max IC(1) IC(2) N Q1 Q3];
    end

end 