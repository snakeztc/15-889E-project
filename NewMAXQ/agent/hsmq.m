function [sp, a, r, terminal, q_tables, exe_stack] = hsmq(s, q_tables, a_tables, terminal_func, ...
    temperature, gamma, learning_rate, exe_stack, exe, cur_step_cnt, max_epi_step)
    
    % while the top of stack is a substak
    while ~is_primitive(exe_stack(end, 1), a_tables)
        top_action = exe_stack(end, 1);
        Q = q_tables{top_action};
        A = a_tables{top_action};
        s_index = s_index_vector(s);
        tempQ = Q(s_index, :);
        for i = 1:size(Q,2)
            if (is_terminal(terminal_func, s, A(i)))
                tempQ(i) = -inf;
            end
        end
        if (exe)
            a_index = greedy_policy(tempQ);
        else
            a_index = boltzman_policy(tempQ, temperature(top_action));
        end
        a = A(a_index);
        exe_stack = vertcat(exe_stack, [a 0 0 s_index]);
    end
    % pop the top action
    a = exe_stack(end, 1);
    
    % execute the action in the domain
    [sp, r, terminal] = taxi_domain(s, a);
    
    % update the primitive action 
    exe_stack(end, 2) = 1;
    exe_stack(end, 3) = r;
    
    % remove completed task 
    last_pop = -1;
    for i = size(exe_stack, 1):-1:1
        if (is_terminal(terminal_func, sp, exe_stack(i, 1)) || is_primitive(exe_stack(i, 1), a_tables)...
                || cur_step_cnt >= max_epi_step) 
            % learn if neccessary
            if (~exe && i > 1)
                pop_action = exe_stack(i, 1);
                pop_step_cnt = exe_stack(i, 2);
                pop_cum_reward = exe_stack(i, 3);
                pop_state_index = exe_stack(i, 4);
                
                parent_action = exe_stack(i-1, 1);
                parent_step_cnt = exe_stack(i-1, 2);

                
                % return cum reward and step cnt to upper level
                exe_stack(i-1, 2) = exe_stack(i-1, 2) + pop_step_cnt;
                exe_stack(i-1, 3) = exe_stack(i-1, 3) + (gamma^parent_step_cnt) * pop_cum_reward;
                
                % begin learn
                Q = q_tables{parent_action};
                A = a_tables{parent_action};
                a_index = find(A==pop_action);
                s_index = pop_state_index;
                sp_index = s_index_vector(sp);
                Q(s_index, a_index) = Q(s_index, a_index) + learning_rate * ...
                    (pop_cum_reward + (gamma^pop_step_cnt) * max(Q(sp_index, :)) - Q(s_index, a_index));
                                
                q_tables{parent_action} = Q;
            end
            last_pop = i;
        end
    end
    if (last_pop > 0)
        exe_stack = exe_stack(1:last_pop-1, :);
    end
end

