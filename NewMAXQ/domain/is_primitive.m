function [result] = is_primitive(a, a_tables)
if (isempty(a_tables{a}))
    result = true;
else
    result = false;
end
end

