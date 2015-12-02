clear;
expTable = importdata('./data/flatRanExpTable.mat');
expTable = datasample(expTable, 30000);
states = expTable(:, 1:4);
actions = expTable(:, 5);
rewards = expTable(:, 6);
nextStates = expTable(:, 7:10);

minQ = -10;
fviQtable = zeros(500, 6) + minQ;
maxIter = 50;
gamma = 0.95;
FVIEvalAvgR = zeros(maxIter, 1);
% convert states to index
sIndex = state2flat(states) + 1;
nsIndex = state2flat(nextStates) + 1;

for i = 1:maxIter
    nextMaxQ = max(fviQtable(nsIndex, :), [], 2);
    y = rewards + gamma * nextMaxQ;
    % update table
    originalQ = zeros(length(y), 1);
    for j = 1:length(y)
        originalQ(j) = fviQtable(sIndex(j), actions(j));
    end
    for j = 1:500
        for k = 1:6
            stateMask = sIndex==j;
            actionMask = actions==k;
            fviQtable(j,k) = mean(y(stateMask & actionMask));
        end
    end
    fviQtable(isnan(fviQtable)) = minQ;
    % compute bellman residual
    resd = mean(abs(y - originalQ));
    disp(['iter ' num2str(i) ' bellman residual is ' num2str(resd)]);
    %FVIEvalAvgR(i) = qEval(fviQtable, 100);
end
qEval(fviQtable, 100);
%plot(FVIEvalAvgR);
%disp(max(FVIEvalAvgR));