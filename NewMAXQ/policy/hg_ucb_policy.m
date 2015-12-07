function [action, cnt_table] = hg_ucb_policy(node, s, exp_bonous, q_tables, a_tables, cnt_table)

state_index = s_index_vector(s);
% record visit frequency
cnt_table(state_index, node) = cnt_table(state_index, node) + 1;
if is_primitive(node, a_tables)
    action = node;
else
    Q = q_tables{node};
    A = a_tables{node};
    node_cnt = cnt_table(state_index, node);
    children_cnt = cnt_table(state_index, A);  
    UCB = Q(state_index, :) ./ children_cnt + exp_bonous * sqrt(log(node_cnt)./children_cnt);
    UCB(isnan(UCB)) = inf;
    [~, maxIdx] = max(UCB);
    a = A(maxIdx);
    [action, cnt_table] = hg_ucb_policy(a, s, exp_bonous, q_tables, a_tables, cnt_table);
end
end

