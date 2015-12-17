clear;
seed = 123456;
rng(seed);
disp(['Using seed ' num2str(seed)]);
%exp_table = importdata('./data/flatRanExpTable.mat');
exp_table = importdata('./data/flatRanStochasExpTable.mat');
total_sample_num = size(exp_table, 1);
sample_sizes = 5000:5000:60000;
gamma = 0.99;
stop_threshold = 0.001;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    disp(['*** sample size ' num2str(sample_sizes(i))]);
    [q_tables, a_tables] = init_tree(6, 1, 500, 6);
    [~, eval_performance(i)] = fqi(exp_table, q_tables, a_tables, sample_sizes(i), 20, gamma, stop_threshold, true);
end
plot(sample_sizes, eval_performance);
