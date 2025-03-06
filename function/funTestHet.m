function pVal = TestHet(Res, X, Whichtest, Yhat)
 
% TESTHET Tests wether heteroskedasticity affects data. Need 'regstats' and 'chi2cdf' (Stat TB).
%
%   PVAL = TESTHET(RES, X, WHICHTEST, YHAT)
%   Inputs:
%   - Res: residuals obtained by regressing Y on x1, x2 etc...(1) It can be a numeric 'n-by-1' vector or 
%          a 'n-by-p' matrix with 'p' residuals obtained from different regressions. The # of obs. is 'n'.
%   - X: predictors suspected of causing heteroskedasticity. Not necessarily all those in (1). Same format as
%        Res.
%   - Whichtest: test chosen in format string. 
%                a. Breush-Pagan, Koenker modification   -->  -BPK      (Breush-Pagan 1979; Koenker 1981)           
%                b. White                                -->  -W        (White 1980b)
%                c. White, Wooldridge special case       -->  -Ws       (White 1980b; Wooldridge 2006, p.286)
%   [OPTIONAL]
%   - Yhat: only for '-Ws' test. Fitted values from (1). Same format as Res.
%
%   Output:
%   A '1-by-p' array with p-values.
%
%   EXAMPLE:
%       1. Regress Y on x1, x2 --> regstats(Y, [x1 x2], 'linear', {'r', 'yhat'})
%       2. Test with -Ws:
%               TestHet(r,[x1, x2], '-Ws', yhat)
%
% See also REGSTATS, CHI2CDF, X2FX
 
% Author: Oleg Komarov (oleg.komarov@hotmail.it)
% Date: 11/07/2009 vers. 1.00 - Last modified: --
% 
% For general econometric reference:
% [1] Greene, W.H. (2003 - 5th ed.) Econometric Analysis. Prentice Hall. 
% [2] Wooldridge, J.M. (2006 - 3rd ed.). Introductory Econometrics: A Modern Approach. Thomson - South West. 
% [3] Kennedy, P. (2008 - 6th ed.). A Guide to Econometrics. Blackwell Publishing. 
 
% ------------------------------------------------------------------------------------------------------------
% CHECK part
% ------------------------------------------------------------------------------------------------------------ 
 
% Ninputs
error(nargchk(3,4,nargin))
% Yhat (for White simpified case)
if strcmp(Whichtest, '-Ws') 
   if nargin == 3
        error('TestHet:YhatMissing','Can''t perform -Ws test without Yhat.')
   end
elseif nargin == 4;
    warning('TestHet:InpOverSpec', 'Performing -W test. Yhat not required.')    
else
    Yhat = ones(size(Res,1)); % for check purposes
end
% Numeric format
if ~isnumeric(X) || ~isnumeric(Res) || ~isnumeric(Yhat)
    error('TestHet:NumericFormat', 'Res, X and Yhat (if specified) must be numeric.')
end
% Whichtest
if ischar(Whichtest) 
    if all(~strcmp(Whichtest, {'-BPK','-W','-Ws'}))
        error('TestHet:WhichtestNotAllowed','Whichtest: choose among those allowed.')
    end
else
    error('TestHet:WhichtestNotString','Whichtest must be a string.')
end
% Nobservations
if any(diff(cellfun(@(x) size(x,1), {Res,X,Yhat})))
    error('TestHet:NumberObservations','Res, X and Yhat (if specified must have the same number of observations')
end
 
 
% ------------------------------------------------------------------------------------------------------------
% ENGINE part
% ------------------------------------------------------------------------------------------------------------
 
% STEP 1: inputs manipulation
% ---------------------------
Res2 = Res.^2;                                                      % Squared residuals
if nargin == 4; 
    Yhat2 = Yhat.^2;                                                % Squared Yhat (for -Ws test only)
end                 
Nseries = size(Res,2);                                              % # of series to test 
pVal = NaN(1,Nseries);                                              % Preallocation
 
% STEP 2: settings
%-----------------
model = 'linear'; Regressors = X;                                   % Default settings            
 
switch Whichtest                                                    % Specific settings
    % [-BPK] Breush-Pagan
    case '-BPK'
        df = size(X,2); % degrees of freedom
    % [-WH] White
    case '-W'
        model = 'quadratic';                          
        % For degrees of freedom don't take the "constant". 
        % Reference on the interaction form : 'x2fx'.  
        df = size(X,2)*2 + max(cumsum(1:size(X,2))) - size(X,2);
    % [-Ws] White special case    
    case '-Ws'
        % Degrees of freedom fixed; the terms are always Yhat and Yhat^2.
        df = 2;
end
 
% STEP 3: p-values
% ----------------
% [1] LOOP for Nseries
for s = 1:Nseries
    % [2a] CONDITION if Ws test, 'Regressors' are combined matrixes
    if strcmpi(Whichtest, '-Ws'); Regressors = [Yhat(:,s),Yhat2(:,s)]; end; %[2a]
    % [2b] CONDITION Regressors+1 must be < Nobserv   
    if df+1 < sum(~isnan(any(Regressors,2)+ Res2(:,s)))
        % 1. R^2res^2: res^2 on the regression terms
        Temp = regstats(Res2(:,s), Regressors, model, {'rsquare'});
        % 2. pVal = 1-cdf(LM statistic, df) from a Chi^2 distribution. 
        %    Where LM statistic = R^2res^2 * #obs 
        pVal(1,s) = 1-chi2cdf(Temp.rsquare*nnz(~isnan(Res2(:,s))),df);
    end % [2b]
    
end % [1]
 
end

