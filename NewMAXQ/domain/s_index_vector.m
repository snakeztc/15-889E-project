function [result] = s_index_vector(states, max_value, min_value)

if nargin < 2
    max_value = [4 5 5 5];
    min_value = [1 1 1 1];
end

% Convert a high dimension state to 1 dimension state index
state_dimension = size(states, 2);
% Construct the base
dimension = length(max_value);
range = max_value - min_value + 1;
base = ones(1, dimension);
for i = dimension-1:-1:1
    base(i) = base(i+1)*range(i+1);
end

% start the conversion
num_instance = size(states, 1);
if state_dimension > 1 % from multi-D to 1D
    base_mask = ones(num_instance, 1) * base;
    minMask = ones(num_instance, 1) * min_value;
    lifted_state = base_mask .* (states - minMask);
    result = sum(lifted_state, 2);
    result = result + 1; % convert from 0-based to 1-based
else
    states = states - 1; % convert from 1-based to 0-based
    result = zeros(num_instance, dimension);
    last_reminder = states;
    for i = 1:dimension
        temp = mod(last_reminder, base(i));
        index = ((last_reminder - temp) / base(i)) + min_value(i);
        result(:, i) = index;
        last_reminder = temp;
    end
end
end


