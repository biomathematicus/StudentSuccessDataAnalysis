sSQL = 'exec spMathMatters1093';
o = funQuery2Cell(sSQL); 
data = cell2mat(o(:,2:3));
idx = data(:,1)==1;
MM = data(idx,2:end);
noMM  = data(~idx,2:end);

%One-sample Kolmogorov-Smirnov test
%[h,p,ksstat,cv] = kstest(mean(noMM,2))
x = mean(MM,2);
y = mean(noMM,2);
[p,h,stats] = ranksum(x,y)

fig = figure(2); clf
x = mean(MM,2);
cdfplot(x);
hold on;
x_values = linspace(min(x),max(x));
plot(x_values,normcdf(x_values,0,1),'r-')
legend('Empirical CDF','Standard Normal CDF','Location','best')

