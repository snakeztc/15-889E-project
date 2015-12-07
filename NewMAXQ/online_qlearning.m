% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
%clear;
clear;
[q_tables, a_tables]  = init_tree(6, 1, 500, 6);
a_tables{end} = 1:6;
max_iter = 5000;
max_epi_step = 1000;
eval_interval = 10000;
learning_rate = 0.2;
init_temp = 50;
temp_decay = 0.95;
gamma = 0.99;
step_cnt = 0;
eval_avg_reward = [];
eval_step = [];
% collect samples and try it for fitted value iter
% we use the format of following:
% s a r s'
exp_table = [];
col = false;

for i = 1:max_iter
    s = gen_init_state();
    local_cnt = 0;
    local_r = 0;
    while 1
        real_temp = init_temp * temp_decay ^ i;
        % update the q_function
        [sp, r, terminal, q_tables] = q_learning(s, q_tables, a_tables, real_temp, gamma, learning_rate, false);
        
        % save the samples
        if (col)
            exp_table = [exp_table; [s a r sp]];
        end
        % check condition
        s = sp;
        step_cnt = step_cnt + 1;
        local_cnt = local_cnt + 1;
        local_r = local_r + r;
        
        % performance evaluation
        if (mod(step_cnt, eval_interval) == 0 || i == max_iter)
            avg_reward = q_eval(q_tables, a_tables, 100, max_epi_step, true, gamma);
            eval_avg_reward = [eval_avg_reward; avg_reward];
            eval_step = [eval_step; step_cnt];
            disp(['iter ' num2str(i) ' having ' num2str(avg_reward) ' with ' num2str(step_cnt)]);
        end
        % check terminal condition
        if terminal == 1 || local_cnt > max_epi_step
            break;
        end
    end
end
plot(eval_step, eval_avg_reward);
%save('./data/flatRanExpTable.mat', 'expTable');








