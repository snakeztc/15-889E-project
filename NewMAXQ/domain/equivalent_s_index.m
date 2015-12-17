function [eq_s_index] = equivalent_s_index(s, s_mask)
all_s = s_index_vector((1:500)');
eq_s_index = find(ismember(all_s(:,s_mask==1),s(s_mask==1), 'rows'));
end

