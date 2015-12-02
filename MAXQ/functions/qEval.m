function [avgR, rewards] = qEval(qtable, numTrial)

rewards = zeros(numTrial, 1);
gamma = 1;
for i = 1:numTrial
    s = initStateGenerate();
    localR = 0;
    localCnt = 0;
    while 1
        %[~, a] = max(qtable(state2flat(s)+1, :));
        a = boltzmanAction(qtable(state2flat(s)+1, :), 0.1);
        [sp, r, terminal] = taxiEnv(s, a);
        s = sp;
        localR = localR + gamma ^ localCnt  * r;
        localCnt = localCnt + 1;
        if terminal == 1 || localCnt > 1000
            break;
        end
    end
    rewards(i) = localR;
end
avgR = mean(rewards);
disp(['Mean is ' num2str(avgR)]);
disp(['Median is ' num2str(median(rewards))]);
disp(['Std is ' num2str(std(rewards))]);
end

