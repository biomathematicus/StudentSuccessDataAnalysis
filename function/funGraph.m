function funGraph()
    %****************** Definitions *************************
    %D = Distance matrix (neighbors)
    %M = Minimum distance matrix
    %T = Tag matrix - Intermediate Nodes Matrix
    %********************************************************
    datestr(now)
    %Retrieve D matrix from databse... pending
    D = [
        0   11  30  inf inf inf inf; ...
        11  0   inf 12  2   inf inf; ...
        30  inf 0   19  inf 4   inf; ...
        inf 12  19  0   11  9   inf; ...
        inf 2   inf 11  0   inf inf; ...
        inf inf 4   9   inf 0   inf; ...
        inf inf inf 20  1   1   0  ; ...
          ];
    M = D;
    n = size(D,1);
    T = [];
    x = 1:n;
    for i=1:n
        T = [T;x];
    end

    %Gomory & Hu algorithm
    ini = now;
    disp(datestr(now))
    for i = 1:n
        for j = 1:n
            for k = 1:n
                if M(i, k) > M(i, j) + M(j, k), M(i, k) = M(i, j) + M(j, k); end
            end
        end 
    end 
    disp(datestr(now-ini));

    %Calculate T based on D & M
    for i = 1:n
        for j = 1:n
            for k = 1:n
                if M(i, j) >= M(i, k) + M(k, j) && D(i, k) < inf && i ~= k && j ~= k 
                    if M(i, j) == inf 
                        T(i, j) = j; 
                    else
                        T(i, j) = k;
                    end
                end 
            end
        end 
    end 
end
