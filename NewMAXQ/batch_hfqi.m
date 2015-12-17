clear;
seed = 123;
rng(seed);
disp(['Using seed ' num2str(seed)]);
[q_tables, a_tables, ~, s_masks] = init_tree1(true);
terminal_func = @is_terminal_tree1;

%exp_table = importdata('./data/flatRanExpTable.mat');
exp_table = importdata('./data/flatRanStochasExpTable.mat');
total_sample_num = size(exp_table, 1);
sample_sizes = 5000:5000:60000;

gamma = 0.99;
stop_threshold = 0.01;
max_iter_num = 50;
verbose = false;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    disp(['*** sample size ' num2str(sample_sizes(i))]);
    q_tables = reset_tree(q_tables);
    temp_exp_table = datasample(exp_table, sample_sizes(i));
    for j = 7:size(q_tables,1)
        q_tables = hfqi(j, temp_exp_table, q_tables, a_tables, terminal_func, s_masks, max_iter_num, gamma, stop_threshold, verbose);
    end
    eval_performance(i) = hsmq_eval(q_tables, a_tables, terminal_func, 100, 1000, true, gamma);
end
plot(sample_sizes, eval_performance);
