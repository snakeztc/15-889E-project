% state is [dest, src, x, y] = [4 5 5 5] = 500
% src = 5 means on taxi
% action 1 up 2 down 3 left 4 right 5 pick up 6 drop
%clear;
clear;
qtable = zeros(500, 6) + 0.123;
maxIter = 5000;
learningRate = 0.2;
initTemp = 50;
tempDecay = 0.95;
gamma = 0.98;
stepCnt = 0;
evalAvgR = [];
evalStep = [];
% collect samples and try it for fitted value iter
% we use the format of following:
% s a r s'
expTable = [];
col = 0;

for i = 1:maxIter
    s = initStateGenerate();
    localCnt = 0;
    localR = 0;
    while 1
        realTemp = initTemp * tempDecay ^ i;
        if realTemp < 0.1
            realTemp = 0;
        end
        a = boltzmanAction(qtable(state2flat(s)+1, :), realTemp);
        [sp, r, terminal] = taxiEnv(s, a);
        prevQsa = qtable(state2flat(s)+1, a);
        nextMaxQsa = max(qtable(state2flat(sp)+1, :));
        qtable(state2flat(s)+1, a) = prevQsa + learningRate * (r + gamma * nextMaxQsa - prevQsa);
        % save the samples
        if col == 1
            expTable = [expTable; [s a r sp]];
        end
        % check condition
        s = sp;
        stepCnt = stepCnt + 1;
        localCnt = localCnt + 1;
        localR = localR + r;
        if (mod(stepCnt, 5000) == 0)
            avgR = qEval(qtable, 100);
            evalAvgR = [evalAvgR; avgR];
            evalStep = [evalStep; stepCnt];
            disp(['iter ' num2str(i) ' having ' num2str(avgR) ' with ' num2str(stepCnt)]);
        end
        if terminal == 1
            break;
        end
    end
end
plot(evalStep, evalAvgR);
%save('./data/flatRanExpTable.mat', 'expTable');








