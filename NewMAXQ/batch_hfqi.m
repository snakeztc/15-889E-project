clear;
rng(12);
[q_tables, a_tables] = init_tree3();
terminal_func = @is_terminal_tree3;

exp_table = importdata('./data/flatRanExpTable.mat');
total_sample_num = size(exp_table, 1);
%sample_sizes = [1000, 2000, 5000, 10000, 20000, 50000];
sample_sizes = 50000;
gamma = 0.99;
stop_threshold = 0.001;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    disp(['*** sample size ' num2str(sample_sizes(i))]);
    q_tables = reset_tree(q_tables);
    temp_exp_table = datasample(exp_table, sample_sizes(i));
    for j = 7:size(q_tables,1)
        q_tables = hfqi(j, temp_exp_table, q_tables, a_tables, terminal_func, 50, gamma, stop_threshold, true);
    end
    eval_performance(i) = hsmq_eval(q_tables, a_tables, terminal_func, 100, 1000, true, gamma);
end
plot(sample_sizes, eval_performance);
