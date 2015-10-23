function [a] = boltzmanAction(qRow, T)
% check infinty
threshold = 0.1;
if T <= threshold
    [~, a] = max(qRow);
    return;
end
temp = qRow/T;
expTemp = exp(temp);
dist = expTemp / sum(expTemp);
cumDis = cumsum(dist);
dice = rand();
a = find(cumDis >= dice, 1);
if (isempty(a))
    disp('ijf');
end
end

