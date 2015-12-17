function [sp, r, terminal, q_tables, a] = q_learning(s, q_tables, a_tables, temperature, gamma, learning_rate, exe)
    if (exe)
        a = greedy_policy(q_tables{end}(s_index_vector(s), :));
    else
        a = boltzman_policy(q_tables{end}(s_index_vector(s), :), temperature);
    end
    [sp, r, terminal] = taxi_domain(s, a);

    % learn if we are not in exe mode
    if (~exe)
        prev_qsa = q_tables{end}(s_index_vector(s), a);
        next_max_qsa = max(q_tables{end}(s_index_vector(sp), :));
        q_tables{end}(s_index_vector(s), a) = prev_qsa + learning_rate * (r + gamma * next_max_qsa - prev_qsa);
    end
end

