%states = importdata('./data/states.mat');
%nextStates = importdata('./data/nextStates.mat');
%actions = importdata('./data/actions.mat');
%rewards = importdata('./data/rewards.mat');
minQ = -10;
fviQtable = zeros(500, 6) + minQ;
maxIter = 50;
gamma = 0.95;
FVIEvalAvgR = zeros(maxIter, 1);
% convert states to index
sIndex = state2flat(states) + 1;
nsIndex = state2flat(nextStates) + 1;

% sample a subset of data
sampleSize = 14000;

[r_rewards, idx] = datasample(rewards, sampleSize);
r_sIndex = sIndex(idx, :);
r_nsIndex = nsIndex(idx, :);
r_actions = actions(idx, :);
%}
%{
r_rewards = rewards(1:sampleSize);
r_sIndex = sIndex(1:sampleSize);
r_nsIndex = nsIndex(1:sampleSize);
r_actions = actions(1:sampleSize);
%}

for i = 1:maxIter
    nextMaxQ = max(fviQtable(r_nsIndex, :), [], 2);
    y = r_rewards + gamma * nextMaxQ;
    % update table
    originalQ = zeros(length(y), 1);
    for j = 1:length(y)
        originalQ(j) = fviQtable(r_sIndex(j), r_actions(j));
    end
    for j = 1:500
        for k = 1:6
            stateMask = r_sIndex==j;
            actionMask = r_actions==k;
            fviQtable(j,k) = mean(y(stateMask & actionMask));
        end
    end
    fviQtable(isnan(fviQtable)) = minQ;
    % compute bellman residual
    resd = mean(abs(y - originalQ));
    disp(['iter ' num2str(i) ' bellman residual is ' num2str(resd)]);
    FVIEvalAvgR(i) = qEval(fviQtable, 100);
end
plot(FVIEvalAvgR);
disp(max(FVIEvalAvgR));