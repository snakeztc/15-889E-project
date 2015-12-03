% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
%clear;
clear;
rng(12);
q_table = zeros(500, 6);
max_iter = 100;
max_epi_step = 1000;
eval_interval = 1000;
batch_size = 1000;
gamma = 0.99;
stop_threshold = 0.001;
step_cnt = 0;
eval_avg_reward = [];
eval_step = [];
% collect samples and try it for fitted value iter
% we use the format of following:
% s a r s'
exp_table = [];

for i = 1:max_iter
    s = gen_init_state();
    local_cnt = 0;
    local_r = 0;
    while 1
        a = random_policy(q_table(s_index_vector(s), :));
        [sp, r, terminal] = taxi_domain(s, a);
        exp_table = vertcat(exp_table, [s a r sp]);
        % check condition
        s = sp;
        step_cnt = step_cnt + 1;
        local_cnt = local_cnt + 1;
        local_r = local_r + r;
        % performance evaluation
        if (mod(step_cnt, eval_interval) == 0 || i == max_iter)
            q_table = fqi(exp_table, q_table, size(exp_table, 1), 50, gamma, stop_threshold, false);
            avg_reward = q_eval(q_table, 100, max_epi_step, true, gamma);
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








