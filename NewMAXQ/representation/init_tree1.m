function [q_tables, a_tables, init_temp, s_masks] = init_tree1(state_abstraction)
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

% state abstraction
if (state_abstraction) 
    s_masks = cell(size(q_tables, 1), 1);
    s_masks{7} = [0 1 1 1]; %navi_get
    s_masks{8} = [1 0 1 1]; %navi_put
    s_masks{9} = [0 1 1 1]; %get
    s_masks{10} = [1 0 1 1]; %put
    s_masks{11} = [0 1 0 0];
else
    s_masks = cell(size(q_tables, 1), 1);
    s_masks{7} = [1 1 1 1];
    s_masks{8} = [1 1 1 1];
    s_masks{9} = [1 1 1 1];
    s_masks{10} = [1 1 1 1];
    s_masks{11} = [1 1 1 1];
end
%}
end

