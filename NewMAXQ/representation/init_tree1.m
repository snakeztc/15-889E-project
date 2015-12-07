function [q_tables, a_tables, init_temp] = init_tree1()
[q_tables, a_tables] = init_tree(6, 5, 500, [4 4 2 2 2]);
a_tables{7} = [1 2 3 4];
a_tables{8} = [1 2 3 4];
a_tables{9} = [5 7];
a_tables{10} = [6 8];
a_tables{11} = [9 10];

% in case we need to run it online
init_temp = zeros(size(q_tables, 1), 1);
init_temp(7) = 12;
init_temp(8) = 12;
init_temp(9) = 25;
init_temp(10) = 25;
init_temp(11) = 50;
end

