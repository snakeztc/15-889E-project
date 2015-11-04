function  batchHsmq(node,expTable)
global qTable
global aTable

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

maxIter = 40;
gamma = 0.96;
%% Subroutine
E = expTable{node};
Q = qTable{node};
% s a(maxq encoding) nr sp a_parent(maxq encoding)
state = E(:, 1:4);
primActions = E(:, 5);
rewards = E(:, 6);
nextStates = E(:, 7:10);
parentA = E(:, 11);

% conver to index
statesIdx = state2flat(state)+1;
nextStateIdx = state2flat(nextStates)+1;


actionIdx = zeros(size(parentA));
numAction = size(Q, 2);
numSample = size(parentA, 1);
curATable = aTable(node,1:numAction); % the node name for action

containSubAction = sum(primActions - parentA) ~= 0;
figure(node);

nonNanMask = ones(numSample, 1);
for i = 1:numSample
    % crate index
    actionIdx(i) = find(curATable==parentA(i));
    % create valid mask
    curPrimA = primActions(i);
    bestA = bestActionHSMQ(parentA(i), statesIdx(i));
    if (bestA ~= curPrimA)
        nonNanMask(i) = 0;
    end
end
nonNanMask = logical(nonNanMask);
disp(['node ' num2str(node)  ' useful ratio '...
    num2str(sum(nonNanMask)/numSample)]);
        
for i = 1:maxIter
    Q = qTable{node};
    originalQ = zeros(numSample,1);
    y = zeros(numSample, 1);
    
    for j = 1:numSample
        originalQ(j) = Q(statesIdx(j), actionIdx(j));
    end
    
    if containSubAction   
        for j = 1:numSample
            if (~nonNanMask(j))
                continue;
            end
            if taxiMaxTermnial(nextStates(j, :), node)
                y(j) = rewards(j);
            else                
                if taxiMaxPrimitve(parentA(j)) || taxiMaxTermnial(nextStates(j, :), parentA(j))
                    y(j) = rewards(j) + gamma * max(Q(nextStateIdx(j), :));
                else
                    y(j) = rewards(j) + gamma * Q(nextStateIdx(j), actionIdx(j));
                end
            end
        end
    else
        y = rewards + gamma * max(Q(nextStateIdx, :), [], 2);
    end
    
    for j = 1:500
        for k = 1:numAction
            stateMask = statesIdx==j;
            actionMask = actionIdx==k;
            target = y(stateMask & actionMask & nonNanMask);
            if (~isempty(target))
                Q(j, k) = mean(target);
            else
                Q(j, k) = -10;
            end
        end
    end
    %}
    qTable{node} = Q;
    plot(Q);
    drawnow
    % compute bellman residual
    resd = mean(abs(y(nonNanMask) - originalQ(nonNanMask)));
    disp(['Iter '  num2str(i) ' node ' num2str(node) ' bellman residual is ' num2str(resd)]);
    if (resd < 0.01)
        break;
    end
end
evalHSMQ(100, true);
end

