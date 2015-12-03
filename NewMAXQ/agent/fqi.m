function [q_table, perforamnce] = fqi(exp_table, q_table, sample_size, max_iter, gamma, stop_threshod, verbose)
perforamnce = 0;
exp_table = datasample(exp_table, sample_size, 1);
states = exp_table(:, 1:4);
actions = exp_table(:, 5);
rewards = exp_table(:, 6);
nextStates = exp_table(:, 7:10);

% convert states to index
s_index = s_index_vector(states);
sp_index = s_index_vector(nextStates);

for i = 1:max_iter
    next_max_q = max(q_table(sp_index, :), [], 2);
    y = rewards + gamma * next_max_q;
    
    % update table
    original_q = zeros(length(y), 1);
    for j = 1:length(y)
        original_q(j) = q_table(s_index(j), actions(j));
    end
    for j = 1:500
        for k = 1:6
            state_mask = s_index ==j;
            action_mask = actions ==k;
            q_table(j,k) = mean(y(state_mask & action_mask));
        end
    end
    q_table(isnan(q_table)) = 0;
    % compute bellman residual
    resd = mean(abs(y - original_q));
    
    if (verbose)
        %disp(['iter ' num2str(i) ' bellman residual is ' num2str(resd)]);
    end
    
    % check stopping criteria
    if (resd < stop_threshod)
        break;
    end
    
end
if (verbose)
    perforamnce = q_eval(q_table, 100, 1000, true, gamma);
end
end

