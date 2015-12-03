function [q_tables, perforamnce] = hfqi(node, exp_table, q_tables, a_tables, ...
    max_iter, gamma, stop_threshold, verbose)

Q = q_tables{node};
A = a_tables{node};
perforamnce = 0;
Qmin = -10;

%% The format of E is: s a nr sp
states = exp_table(:, 1:4);
prim_actions = exp_table(:, 5);
rewards = exp_table(:, 6);
next_states = exp_table(:, 7:10);

%% convert states to index
states_idx = s_index_vector(states);
next_state_idx = s_index_vector(next_states);

%% Intialize variables
num_action = size(Q, 2);
num_sample = size(states, 1);

%% Check if the node contains any subtask action as its direct children
if (verbose == 1)
    figure(node);
end

non_nan_mask = ones(num_sample, num_action);
%% Filter the experince table and locate relevant experience tuples
for i = 1:num_sample
    for j = 1:num_action
        % create valid mask
        cur_prim_a = prim_actions(i);
        best_a = h_greedy_policy(A(j), states(i, :), q_tables, a_tables);
        if (best_a ~= cur_prim_a)
            non_nan_mask(i, j) = 0;
        end
    end
end
non_nan_mask = logical(non_nan_mask);
% calculate what percentage data is useful in learning this node's policy
if (verbose)
    disp(['node ' num2str(node)  ' relevant ratio ' num2str(sum(sum(non_nan_mask, 2)>0)/num_sample)]);
end

%% Begin value iteration
for i = 1:max_iter
    Q = q_tables{node};
    original_q = zeros(num_sample,num_action);
    y = zeros(num_sample, num_action);
    
    % find the intial q values for all actions before Bellman backup
    for j = 1:num_sample
        for k = 1:num_action
            original_q(j, k) = Q(states_idx(j), k);
        end
    end
    
    % if node contains subtask action
    for j = 1:num_sample
        for k = 1:num_action
            % Skip irrevelant samples
            if (~non_nan_mask(j, k))
                continue;
            end
            if is_terminal(next_states(j, :), node)
                y(j, k) = rewards(j);
            else                
                if is_primitive(A(k)) || is_terminal(next_states(j, :), A(k))
                    y(j, k) = rewards(j) + gamma * max(Q(next_state_idx(j), :));
                else
                    y(j, k) = rewards(j) + gamma * Q(next_state_idx(j), k);
                end
            end
        end
    end
    
    %% for each state, action pair, compute the emperical mean of Q_node(s, a)
    for j = 1:500
        for k = 1:num_action
            state_mask = states_idx==j;
            target = y(state_mask & non_nan_mask(:, k), k);
            if (~isempty(target))
                Q(j, k) = mean(target);
            else
                Q(j, k) = Qmin;
            end
        end
    end
    q_tables{node} = Q;
    if (verbose == 1)
        plot(Q);
        drawnow
    end
    
    %% compute bellman residual
    resd = mean(abs(y(non_nan_mask) - original_q(non_nan_mask)));
    if (verbose)
        disp(['Iter '  num2str(i) ' node ' num2str(node) ' bellman residual is ' num2str(resd)]);
    end
    if (resd < stop_threshold)
        break;
    end
end

%% evaluate the entire policy by 100 trials in the simulato
if (verbose == 1)
    perforamnce = hsmq_eval(q_tables, a_tables, 100, 1000, true, gamma);
end

end

