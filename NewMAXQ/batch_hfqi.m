clear;
rng(12);
[q_tables, a_tables] = init_tree(6, 5, 500, [4 4 2 2 2]);
a_tables{7} = [1 2 3 4];
a_tables{8} = [1 2 3 4];
a_tables{9} = [5 7];
a_tables{10} = [6 8];
a_tables{11} = [9 10];

terminal_func = @is_terminal_tree1;

exp_table = importdata('./data/flatRanExpTable.mat');
total_sample_num = size(exp_table, 1);
sample_sizes = [1000, 2000, 5000, 10000, 20000, 50000];
gamma = 0.99;
stop_threshold = 0.001;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    disp(['*** sample size ' num2str(sample_sizes(i))]);
    q_tables = reset_tree(q_tables);
    temp_exp_table = datasample(exp_table, sample_sizes(i));
    for j = 7:11
        q_tables = hfqi(j, temp_exp_table, q_tables, a_tables, terminal_func, 50, gamma, stop_threshold, false);
    end
    eval_performance(i) = hsmq_eval(q_tables, a_tables, terminal_func, 100, 1000, true, gamma);
end
plot(sample_sizes, eval_performance);
