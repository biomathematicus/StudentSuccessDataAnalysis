function [nIni, nEnd] = funFirstNotNaN(m)
% funFirstNotNaN(m)
% finds first row in the matrix m that contains entirely finite elements
    % idx = isnan(m);
    idx = ~isfinite(m); % is Nan or is Inf
    idx = sum(idx,2) == 0;
    nIni = find(idx,1,'first');
    nEnd = find(idx,1,'last');
end

