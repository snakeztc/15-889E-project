function [ avgR, rewards ] = maxqEval(vTable, cTable, aTable, numTrial)

rewards = zeros(numTrial, 1);
for i = 1:numTrial
    %disp('a new round');
    pass = randi(4);
    dest = randi(4);
    car = randi(5, 2, 1)';
    s = [dest, pass, car];
    [~, ~, R] = exeMaxq(1, s, vTable, cTable, aTable, 0);
    rewards(i) = R;
end
avgR = mean(rewards(rewards ~= 0));
end

