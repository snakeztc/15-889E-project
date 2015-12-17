function [q_tables, a_tables, init_temp, s_masks] = init_tree2(state_abstraction)
[q_tables, a_tables] = init_tree(6, 3, 500, [5 5 2]);
a_tables{7} = [1 2 3 4 5];
a_tables{8} = [1 2 3 4 6];
a_tables{9} = [7 8];

init_temp = zeros(size(q_tables, 1), 1);
init_temp(7) = 25;
init_temp(8) = 25;
init_temp(9) = 50;

% state abstraction
if (state_abstraction)
    s_masks = cell(size(q_tables, 1), 1);
    s_masks{7} = [0 1 1 1];  % get
    s_masks{8} = [1 0 1 1];  % put
    s_masks{9} = [0 1 0 0];
else
    s_masks = cell(size(q_tables, 1), 1);
    s_masks{7} = [1 1 1 1];  % get
    s_masks{8} = [1 1 1 1];  % put
    s_masks{9} = [1 1 1 1];
end
end
