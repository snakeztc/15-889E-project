function [a] = boltzman_policy(q_row, T)
% check infinty
threshold = 0.1;
if T <= threshold || length(q_row) == 1
    [~, a] = max(q_row);
    return;
end
temp = q_row/T;
exp_temp = exp(temp);
dist = exp_temp / sum(exp_temp);
cum_dist = cumsum(dist);
cum_dist(isnan(cum_dist)) = -inf;
dice = rand();
a = find(cum_dist >= dice, 1);
if (isempty(a))
    disp('error in boltzman_policy');
end
end


