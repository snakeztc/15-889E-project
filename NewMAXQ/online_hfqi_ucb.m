% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
%clear;
clear;
rng(12);
q_tables = cell(11, 1); % the first 6 will be empty 
q_tables{7} = zeros(500, 4); %navi_get
q_tables{8} = zeros(500, 4); %navi_put
q_tables{9} = zeros(500, 2); %get
q_tables{10} = zeros(500, 2); %put
q_tables{11} = zeros(500, 2); %root

a_tables = cell(11, 1);
a_tables{7} = [1 2 3 4];
a_tables{8} = [1 2 3 4];
a_tables{9} = [5 7];
a_tables{10} = [6 8];
a_tables{11} = [9 10];

cnt_table = zeros(500, 11);

exp_bonous = 10;
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
        [a, cnt_table] = hg_ucb_policy(11, s, exp_bonous, q_tables, a_tables, cnt_table);
        [sp, r, terminal] = taxi_domain(s, a);
        exp_table = vertcat(exp_table, [s a r sp]);
        % check condition
        s = sp;
        step_cnt = step_cnt + 1;
        local_cnt = local_cnt + 1;
        local_r = local_r + r;
        if (mod(step_cnt, batch_size) == 0)
            for j = 7:11
                q_tables = hfqi(j, exp_table, q_tables, a_tables,50, gamma, stop_threshold, false);
            end
        end
        % performance evaluation
        if (mod(step_cnt, eval_interval) == 0)
            avg_reward = hsmq_eval(q_tables, a_tables, 100, 1000, true, gamma);
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
avg_reward = hsmq_eval(q_tables, a_tables, 100, 1000, true, gamma);
eval_avg_reward = [eval_avg_reward; avg_reward];
eval_step = [eval_step; step_cnt];
plot(eval_step, eval_avg_reward);








