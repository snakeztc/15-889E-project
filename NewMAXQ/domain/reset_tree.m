function [q_tables] = reset_tree(q_tables)
for i = 1:size(q_tables, 1)
    if (~isempty(q_tables{i}))
        q_size = size(q_tables{i});
        q_tables{i} = zeros(q_size);
    end
end
end

