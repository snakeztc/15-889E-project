function [q_tables, perforamnce] = hfqi(node, exp_table, q_tables, a_tables, terminal_func, ...
    s_masks, max_iter, gamma, stop_threshold, verbose)

Q = q_tables{node};
A = a_tables{node};
S_MASK = s_masks{node};
perforamnce = 0;
Qmin = -10.123;

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

consistent_mask = ones(num_sample, num_action);
%% Filter the experince table and locate relevant experience tuples
for i = 1:num_sample
    for j = 1:num_action
        % create valid mask
        cur_prim_a = prim_actions(i);
        best_a = h_greedy_policy(A(j), states(i, :), q_tables, a_tables);
        if (best_a ~= cur_prim_a)
            consistent_mask(i, j) = 0;
        end
    end
end
consistent_mask = logical(consistent_mask);
% calculate what percentage data is useful in learning this node's policy
if (verbose)
    disp(['node ' num2str(node)  ' relevant ratio ' num2str(sum(sum(consistent_mask, 2)>0)/num_sample)]);
end

%% compute equivalent state mask at once
all_state_mask = zeros(num_sample, 500); 
all_eq_s_index = cell(500, 1);
for i = 1:500
    eq_s_index = equivalent_s_index(s_index_vector(i), S_MASK);
    temp = ismember(states_idx, eq_s_index);
    all_state_mask(:, i) = temp;
    all_eq_s_index{i} = eq_s_index;
end


%% Begin value iteration
for i = 1:max_iter
    Q = q_tables{node};
    old_Q = Q;
    y = zeros(num_sample, num_action);
    
    % if node contains subtask action
    for j = 1:num_sample
        for k = 1:num_action
            % Skip irrevelant samples
            if (~consistent_mask(j, k))
                continue;
            end
            if is_terminal(terminal_func, next_states(j, :), node)
                y(j, k) = rewards(j);
            else                
                if is_primitive(A(k), a_tables) || is_terminal(terminal_func, next_states(j, :), A(k))
                    y(j, k) = rewards(j) + gamma * max(Q(next_state_idx(j), :));
                else
                    y(j, k) = rewards(j) + gamma * Q(next_state_idx(j), k);
                end
            end
        end
    end
    
    %% for each state, action pair, compute the emperical mean of Q_node(s, a)
    for j = 1:500
        eq_s_index = all_eq_s_index{j};
        state_mask = all_state_mask(:, j);
        for k = 1:num_action
            target = y(state_mask & consistent_mask(:, k), k);
            if (~isempty(target))
                Q(eq_s_index, k) = mean(target);
            else
                Q(eq_s_index, k) = Qmin;
            end
        end
    end
        
    q_tables{node} = Q;
    if (verbose == 1)
        plot(Q);
        drawnow
    end
    
    %% compute Q table differences
    resd = norm(old_Q - Q);
    if (verbose)
        disp(['Iter '  num2str(i) ' node ' num2str(node) ' Q norm differences is ' num2str(resd)]);
    end
    if (resd < stop_threshold)
        break;
    end
end

%% evaluate the entire policy by 100 trials in the simulato
if (verbose == 1)
    perforamnce = hsmq_eval(q_tables, a_tables, terminal_func, 100, 1000, true, gamma);
end

end

