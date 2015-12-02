function [result] = a_index_string(a)
% if a is a number it will try to map it to its index
% if a is a word, it will convert it back to index
action_strings = {'up', 'down', 'left', 'right', 'pick', 'drop',...
                    'get', 'put', 'navi_get', 'navi_put', 'root'};
if (isnumeric(a))
    result = 'None';
    if (a > 0 && a < 12)
        result = action_strings{a};
    end
else
    result = -1;
    array = strfind(action_strings, a);
    mask = double(cellfun(@isempty,array));
    if (sum(mask) ~= length(mask))
        % we found the string
        result = find(mask==0);
    end
end
end

