function [avg_reward, rewards] = hsmq_eval(q_tables, a_tables, num_trail, max_epi_step, discount, gamma)
    if (~discount) 
        gamma = 1;
    end
    rewards = zeros(num_trail, 1);
    for i = 1:num_trail
        s = gen_init_state();
        exe_stack = [11 0 0 s_index_vector(s)];
        local_r = 0;
        local_cnt = 0;
        while ~isempty(exe_stack)
            [sp, ~, r, ~, q_tables, exe_stack] = hsmq(s, q_tables, a_tables, 0, gamma,...
                0, exe_stack, true, local_cnt, max_epi_step);
            s = sp;
            local_r = local_r + gamma ^ local_cnt  * r;
            local_cnt = local_cnt + 1;
        end
        if (~discount)
            local_r = local_r/local_cnt;
        end
        rewards(i) = local_r;
    end
    avg_reward = mean(rewards);
    disp(['Mean is ' num2str(avg_reward)]);
    disp(['Median is ' num2str(median(rewards))]);
    disp(['Std is ' num2str(std(rewards))]);
end