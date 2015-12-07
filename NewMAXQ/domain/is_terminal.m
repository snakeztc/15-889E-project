function [result] = is_terminal(func, s, a)
result = feval(func, s, a);
end

