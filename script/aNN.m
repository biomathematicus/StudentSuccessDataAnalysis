config
sStart = '2014.66';
sEnd = '2015.33';

sFileName = ['aNN-' ... 
            strrep(sStart,'.','-') '-' ...
            strrep(sEnd,'.','-') ...
            ];
%sDataFile = ['../data/' sFileName '.mat']; 
sDataFile = [sFileName '.mat']; 
if exist(sDataFile,'file') 
    load(sDataFile);
else
    sSQL = ['exec spStudentDemographics ''new'', ' ...
                sStart ',' ...
                sEnd ];
    try
        o = funQuery2Matrix(sSQL); 
        save(sDataFile, 'o')
    catch e
        disp(e)
    end
end
%o = normalize(o);
%o(:,5) = normalize(o(:,5));
%o(:,6) = normalize(o(:,6));
%o(:,5) = [];
idx = o(:,end) ==1;

% Visualize all variables
figure(5); clf; k=0;
for i = 1:size(o,2)-1
    for j = 1:size(o,2)-1
        k = k+1;
        subplot(size(o,2),size(o,2),k)
        plot(o(idx,i), o(idx,j),'r*');
        hold on
        plot(o(~idx,i), o(~idx,j),'bo');
        hold off
        title([num2str(i) '-' num2str(j)])
    end    
end

M = o(:,[1,2,4,7,8]);%1:end-1); %)%[o(:,3),o(:,5),o(:,6),o(:,7),o(:,8)];

% ANN
x = M;% o(:,1:end-1);
n = size(x,1);
t = o(:,end);
x = x';
t = t';
rng(1);     % for reproducibility
% hold out 1/3 of the dataset
c = cvpartition(n,'Holdout',(n-mod(n,3))/3); 

Xtrain = x(:, training(c));    % 2/3 of the input for training
Ytrain = t(:, training(c));  % 2/3 of the target for training
Xtest = x(:, test(c));         % 1/3 of the input for testing
Ytest = t(test(c));           % 1/3 of the target for testing

%sweep = [6:2:20]; %4000-level in 5 years - Optimal = 14
sweep = 14;
scores = zeros(length(sweep), 1);       % pre-allocation
models = cell(length(sweep), 1);        % pre-allocation
%x = Xtrain;                             % inputs
%t = Ytrain;                             % targets
trainFcn = 'trainscg';                  % scaled conjugate gradient
for i = 1:length(sweep)
    nSize = sweep(i);         % number of hidden layer neurons
    % feedforwardnet  patternnet  fitnet
    net = patternnet([nSize,nSize]);  % pattern recognition network
    net.divideParam.trainRatio = 70/100;% 70% of data for training
    net.divideParam.valRatio = 15/100;  % 15% of data for validation
    net.divideParam.testRatio = 15/100; % 15% of data for testing
    net = train(net, Xtrain, Ytrain);             % train the network
    models{i} = net;                    % store the trained network
    p = net(Xtest);                     % predictions
    scores(i) = norm(p-Ytest);          % RMSE
end
figure
plot(sweep, scores, '.-')
xlabel('number of hidden neurons')
ylabel('categorization accuracy')
title('Number of hidden neurons vs. accuracy')

%PCA
M = (M - mean(M))./std(M);
V = M'*M;
[V,D] = eig(V);
xx = M*V(:,end);
yy = M*V(:,end-1);
zz = M*V(:,end-2);
figure(6); clf
plot3(xx(idx),yy(idx),zz(idx),'r*'); hold on
plot3(xx(~idx),yy(~idx),zz(~idx),'b^'); hold off







%net = feedforwardnet([100,100]);
net = fitnet(20);
[net, tr] = train(net,x,t);
%view(net)
y = net(x);
perf = perform(net,y,t)
disp('')