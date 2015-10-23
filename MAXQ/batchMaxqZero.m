function  batchMaxqZero(node, states, nextStates, actions, rewards, expTable)
global vTable
global cTable
global aTable
global totalStep

% this function is designed just work for taxi
% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), up(8), down(9), left(10), right(11).
%
% vTable: numNode * 1 cell
% inside: numS * numA matrix
% cTable: numNode * 1 cell
% inside: numS * numA matrix
% aTable contains the avaliable action for node 1 2 3 6 7
%disp(['in node ' num2str(node) ' with state ' num2str(sIndex)]);

maxIter = 15;
gamma = 0.96;
Cmin = 0.123;
if (node > 7 || node == 4 || node == 5)
    sIndex = state2flat(states) + 1;
    V = vTable{node};
    % no iteration is needed. We get the emperic mean
    if (node > 7) 
        a = node -7;
    else
        a = node + 1;
    end    
    acttiveMask = actions == a;
    activeReward = rewards(acttiveMask);
    activeStates = sIndex(acttiveMask);    
    for i = 1:length(V) 
        V(i) = mean(activeReward(activeStates==i));
    end
    V(isnan(V)) = Cmin;
    % save
    vTable{node} = V;
    return;
end

%% Subroutine
E = expTable{node};
C = cTable{node};
% sample a subset
%sampleSize = 30000;
%E = datasample(E, sampleSize);

subStates = E(:, 1:4);
subActions = E(:, 5);
subN = E(:, 6);
subNextStaes = E(:, 7:end);
subStatesIdx = state2flat(subStates)+1;
subActionIdx = zeros(size(subActions));
numAction = size(C, 2);
numSample = size(subN, 1);
curATable = aTable(node,1:numAction); % the node name for action

for i = 1:numSample
    subActionIdx(i) = find(curATable==subActions(i));
end

for i = 1:maxIter
    C = cTable{node};
    originalC = zeros(numSample,1);
    y = zeros(numSample, 1);
    
    for j = 1:numSample
        originalC(j) = C(subStatesIdx(j), subActionIdx(j));
        if node == 6 || node == 7
            newN = 1;
        else
            totalStep = 0; [~, ~, newN]= maxqzero(subActions(j), subStates(j, :), 0, 1, 0);
        end
        y(j) = gamma^newN* evalMaxNode(node, subNextStaes(j,:), 0);
    end
    %{
    for j = 1:numSample
        C = cTable{node};
        y(j) = evalMaxNode(node, subNextStaes(j,:), 0);
        C(subStatesIdx(j), subActionIdx(j)) = 0.6*C(subStatesIdx(j), subActionIdx(j))...
            + 0.4*gamma^subN(j)* y(j);
        cTable{node} = C;
    end
    %}
    for j = 1:500
        for k = 1:numAction
            stateMask = subStatesIdx==j;
            actionMask = subActionIdx==k;
            C(j, k) = mean(y(stateMask & actionMask));
        end
    end
    %}
    C(isnan(C)) = Cmin;
    cTable{node} = C;
    % compute bellman residual
    resd = mean(abs(y - originalC));
    disp(['Iter '  num2str(i) ' node ' num2str(node) ' bellman residual is ' num2str(resd)]);
    if (resd < 10e-8)
        break;
    end
end
disp(maxqEval(100));
end

