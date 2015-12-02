% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
% subtask 7 navi_get, 8 navi_put, 9 get, 10 put, 11 root
%clear;
clear;
rng(12);
%% Representation
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

init_temp = zeros(11, 1);
init_temp(7) = 12.5;
init_temp(8) = 12.5;
init_temp(9) = 25;
init_temp(10) = 25;
init_temp(11) = 50;
%}

%% Hyper parameters
max_iter = 5000;
max_epi_step = 1000;
eval_interval = 10000;
learning_rate = 0.5;
temp_decay = 0.95;
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
    exe_stack = [11 0 0 s_index_vector(s)];
    local_cnt = 0;
    local_r = 0;
    real_temp = init_temp * temp_decay ^ i;
    while ~isempty(exe_stack)
        % update the q_function
        [sp, a, r, terminal, q_tables, exe_stack] = hsmq(s, q_tables, a_tables,...
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
avg_reward = hsmq_eval(q_tables, a_tables, 100, max_epi_step, true, gamma);
eval_avg_reward = [eval_avg_reward; avg_reward];
eval_step = [eval_step; step_cnt];
plot(eval_step, eval_avg_reward);
%save('./data/flatRanExpTable.mat', 'expTable');








