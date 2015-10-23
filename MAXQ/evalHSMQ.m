function [avgR, rewards] = evalHSMQ(numTrial, verbose)
global totalStep

if (nargin < 2)
    verbose = false;
end

rewards = zeros(numTrial, 1);
for i = 1:numTrial
    %disp('a new round');
    s = initStateGenerate();
    totalStep = 0;
    [~, R, ~]  = HSMQ(1, s, 10, 1);
    rewards(i) = R;
end
avgR = mean(rewards);

if (verbose)
    disp(['Mean is ' num2str(avgR)]);
    disp(['Median is ' num2str(median(rewards))]);
    disp(['Std is ' num2str(std(rewards))]);
end
end

