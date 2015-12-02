function [result] = is_primitive(a)
if iscell(a)
    disp('wrong');
    result = -1;
    return;
end
if (a < 7)
    result = true;
else
    result = false;
end
end

