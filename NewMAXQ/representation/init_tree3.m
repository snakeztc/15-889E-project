function [q_tables, a_tables, init_temp] = init_tree3()
[q_tables, a_tables] = init_tree(6, 3, 500, [4 4 4]);
a_tables{7} = [1 2 3 4];
a_tables{8} = [1 2 3 4];
a_tables{9} = [7 8 5 6];

init_temp = zeros(size(q_tables, 1), 1);
init_temp(7) = 25;
init_temp(8) = 25;
init_temp(9) = 50;
end

