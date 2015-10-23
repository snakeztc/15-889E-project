function [ avgR, rewards ] = maxqEval(numTrial)
global totalStep
rewards = zeros(numTrial, 1);
for i = 1:numTrial
    s = initStateGenerate();
    totalStep = 0;
    [~, R] = maxqzero(1, s, 5, 1);
    rewards(i) = R;
end
avgR = mean(rewards(rewards ~= 0));
end

