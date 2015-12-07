function [result] = h_greedy_policy(node, s, q_tables, a_tables)
if (is_primitive(node, a_tables))
    result = node;
else
    Q = q_tables{node};
    A = a_tables{node};
    [~, a_index] = max(Q(s_index_vector(s), :));
    a = A(a_index);
    result = h_greedy_policy(a, s, q_tables, a_tables);
end
end

