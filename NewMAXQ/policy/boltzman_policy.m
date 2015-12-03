function [a] = boltzman_policy(q_row, T)
% check infinty
threshold = 0.1;
if T <= threshold
    [~, a] = max(q_row);
    return;
end
temp = q_row/T;
exp_temp = exp(temp);
dist = exp_temp / sum(exp_temp);
cum_dist = cumsum(dist);
dice = rand();
a = find(cum_dist >= dice, 1);
if (isempty(a))
    disp('error in boltzman_policy');
end
end


