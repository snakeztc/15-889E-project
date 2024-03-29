% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
% subtask 7 navi_get, 8 navi_put, 9 get, 10 put, 11 root
%clear;
clear;
rng(12);
%% Representation
[q_tables, a_tables, init_temp] = init_tree2();
terminal_func = @is_terminal_tree2;

%% Hyper parameters
max_iter = 5000;
max_epi_step = 1000;
eval_interval = 10000;
learning_rate = 0.5;
temp_decay = 0.98;
gamma = 0.99;
step_cnt = 0;
eval_avg_reward = [];
eval_step = [];
train_reward = zeros(max_iter, 1);
% collect samples and try it for fitted value iter
% we use the format of following:
% s a r s'
exp_table = [];
col = false;
% the format of exe_stack is [action_name step cum_reward init_s_index]

%% Experiemnt running
for i = 1:max_iter
    s = gen_init_state();
    exe_stack = [size(q_tables, 1) 0 0 s_index_vector(s)];
    local_cnt = 0;
    local_r = 0;
    real_temp = init_temp * temp_decay ^ i;
    while ~isempty(exe_stack)
        % update the q_function
        [sp, a, r, terminal, q_tables, exe_stack] = hsmq(s, q_tables, a_tables, terminal_func,...
          real_temp, gamma, learning_rate, exe_stack,false, local_cnt, max_epi_step);
        
        % update state
        s = sp;
        step_cnt = step_cnt + 1;
        local_r = local_r + gamma ^ local_cnt * r;
        local_cnt = local_cnt + 1;
        
        % performance evaluation
        if (mod(step_cnt, eval_interval) == 0)
            %avg_reward = hsmq_eval(q_tables, a_tables, 100, max_epi_step, true, gamma);
            avg_reward = mean(train_reward(max(1, i-100):i-1));
            eval_avg_reward = [eval_avg_reward; avg_reward];
            eval_step = [eval_step; step_cnt];
            disp(['iter ' num2str(i) ' having ' num2str(avg_reward) ' with ' num2str(step_cnt)]);
        end
        train_reward(i) = local_r;
    end
end
avg_reward = hsmq_eval(q_tables, a_tables, terminal_func, 100, max_epi_step, true, gamma);
eval_avg_reward = [eval_avg_reward; avg_reward];
eval_step = [eval_step; step_cnt];
plot(eval_step, eval_avg_reward);
%save('./data/flatRanExpTable.mat', 'expTable');








