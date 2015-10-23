function [result] = state2flat(states, maxValue, minValue)

if nargin < 2
    maxValue = [4 5 5 5];
    minValue = [1 1 1 1];
end

% Convert a high dimension state to 1 dimension state index
StateDimension = size(states, 2);
% Construct the base
dimension = length(maxValue);
range = maxValue - minValue + 1;
base = ones(1, dimension);
for i = dimension-1:-1:1
    base(i) = base(i+1)*range(i+1);
end

% start the conversion
numInstance = size(states, 1);
if StateDimension > 1 % from high D to 1D
    baseMask = ones(numInstance, 1) * base;
    minMask = ones(numInstance, 1) * minValue;
    liftedState = baseMask .* (states - minMask);
    result = sum(liftedState, 2);    
else
    result = zeros(numInstance, dimension);
    lastReminder = states;
    for i = 1:dimension
        temp = mod(lastReminder, base(i));
        index = ((lastReminder - temp) / base(i)) + minValue(i);
        result(:, i) = index;
        lastReminder = temp;
    end
end
end

