clear;
rng(12);
q_tables = cell(11, 1); % the first 6 will be empty 
a_tables = cell(11, 1);
a_tables{7} = [1 2 3 4];
a_tables{8} = [1 2 3 4];
a_tables{9} = [5 7];
a_tables{10} = [6 8];
a_tables{11} = [9 10];

exp_table = importdata('./data/flatRanExpTable.mat');
total_sample_num = size(exp_table, 1);
sample_sizes = [1000, 2000, 5000, 10000, 20000, 50000];
gamma = 0.99;
stop_threshold = 0.001;
eval_performance = zeros(length(sample_sizes), 1);

for i = 1:length(sample_sizes)
    q_tables{7} = zeros(500, 4); %navi_get
    q_tables{8} = zeros(500, 4); %navi_put
    q_tables{9} = zeros(500, 2); %get
    q_tables{10} = zeros(500, 2); %put
    q_tables{11} = zeros(500, 2); %root
    temp_exp_table = datasample(exp_table, sample_sizes(i));
    for j = 7:11
        q_tables = hfqi(j, temp_exp_table, q_tables, a_tables,50, gamma, stop_threshold, false);
    end
    eval_performance(i) = hsmq_eval(q_tables, a_tables, 100, 1000, true, gamma);
end
plot(sample_sizes, eval_performance);
