function [avg_reward, rewards] = q_eval(q_table, num_trail, max_epi_step, discount, gamma)
    if (~discount) 
        gamma = 1;
    end
    rewards = zeros(num_trail, 1);
    for i = 1:num_trail
        s = gen_init_state();
        local_r = 0;
        local_cnt = 0;
        while 1
            [sp, r, terminal] = q_learning(s, q_table, 0, gamma, 0, true);
            s = sp;
            local_r = local_r + gamma ^ local_cnt  * r;
            local_cnt = local_cnt + 1;
            if terminal == 1 || local_cnt > max_epi_step
                break;
            end
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