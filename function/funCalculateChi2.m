function [TABLE TABLEn]=funCalculateChi2(mVariable1,mVariable2, sVar1, sVar2,sVar3,  TABLE, TABLEn)
    

    TABLE = [TABLE; 0,0,0,0,0,0];
    TABLEn = [TABLEn; {'', '',''}];
    table=zeros(2,2);
    idxNaN1=isnan(mVariable1);
    mVariable1(idxNaN1)=[];mVariable2(idxNaN1)=[];
    [table,chi2,p]=crosstab(mVariable1,mVariable2);
     
    V2=funCountMatrixElements(mVariable2,1);
    Vs2=funCountMatrixElements(mVariable2,2);
        if (size(table,1)~=1 & size(table,2)~=1 );

            TABLE(end,1)=table(1,1);
            TABLE(end,3)=table(1,2); 
            TABLE(end,5)=p;
            TABLE(end,2)=table(1,1)/sum(table(:,1))*100;
            TABLE(end,4)=table(1,2)/sum(table(:,2))*100;
        else if (size(table,2)==1)
                if (sum(table)==Vs2);
                    TABLE(end,1)=0;
                    TABLE(end,2)=0;
                    TABLE(end,5)=p;
                    TABLE(end,3)=table(2);
                    TABLE(end,4)=table(2)/sum(table)*100;
                else 
                    TABLE(end,1)=table(1);
                    TABLE(end,2)=table(1)/sum(table);
                    TABLE(end,5)=p;
                    TABLE(end,3)=0;
                    TABLE(end,4)=0;
                end 
            else if (size(table,1)==1);
                    A=unique(mVariable1);
                    if (size(A,1)==1 && A==1)
                        TABLE(end,1)=sum(table(:,1));
                        TABLE(end,3)=sum(table(:,2));
                        TABLE(end,5)=p;
                        TABLE(end,2)=100;
                        TABLE(end,4)=100;
                    else
                        TABLE(end,1)=0;
                        TABLE(end,3)=0;
                        TABLE(end,5)=p;
                        
                        TABLE(end,2)=0;
                        TABLE(end,4)=0;
                    end
                end 
            end 
                
        end

    TABLEn{end,1}={sVar1};
    TABLEn{end,2}={sVar2};
    TABLEn{end,3}={sVar3};
    [pvalue table]=FisherExactTest22(mVariable1,mVariable2);
    for i=1:4;
        if table(i) <=5;
        T(i,1)=1;
        else
            T=0;
        end
    end
    if sum(T)>1;
        [pvalue]=FisherExactTest22(mVariable1,mVariable2);
        TABLE(end,6)=pvalue(3);
    else
        TABLE(end,6)=p;
    end
end
                       
                       