function f = funSmoothFourier(y,m)
% This function produces a smooth time series
% Author: Juan B. Gutierrez - juan@math.uga.edu
% Date: 11/2013
%
% params: y - numeric vector, vector to be filtered
% params: w - integer, the filtering parameter
%
% Copyright Juan B Gutierrez 2013
% Based on work by Juan B. Gutierrez (c) 2010
% This code can be reused as long as proper credits appear. You can use
% this code but you cannot present it as your own work. If substantial
% modifications occur, the following disclosure must appear:
% "Based on work by Juan B. Gutierrez (c) 2010"

    % y = raw data vector
    % n = frequencies that we want to keep
    f = fft(y);
    n = size(y,1);
    B = sort(f);
    [~,uIdx] = ismember(f,B); % Index to reverse sort: f = B(uIdx)
    idx = 1:(size(y,1)-m);
    B(idx) = 0;
    f = real(ifft(B(uIdx)));
end