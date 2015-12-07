function [q_tables, a_tables] = init_tree(num_prim_action, num_subtask, num_state, num_branch)
q_tables = cell(num_prim_action + num_subtask, 1);
a_tables = cell(num_prim_action + num_subtask, 1);
for i = num_prim_action+1 : num_prim_action+num_subtask
    q_tables{i} = zeros(num_state, num_branch(i-num_prim_action));
end
end

