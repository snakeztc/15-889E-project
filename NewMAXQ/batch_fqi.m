clear;
rng(12);
exp_table = importdata('./data/flatRanExpTable.mat');
total_sample_num = size(exp_table, 1);
sample_sizes = [1000, 2000, 5000, 10000, 20000, 50000];
gamma = 0.99;
stop_threshold = 0.001;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    disp(['*** sample size ' num2str(sample_sizes(i))]);
    [q_tables, a_tables] = init_tree(6, 1, 500, 6);
    [~, eval_performance(i)] = fqi(exp_table, q_tables, a_tables, sample_sizes(i), 50, gamma, stop_threshold, true);
end
plot(sample_sizes, eval_performance);
