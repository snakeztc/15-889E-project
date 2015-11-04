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
% disp(['in node ' num2str(node) ' with state ' num2str(sIndex)]);

maxIter = 40;
gamma = 0.96;

E = expTable{node};
Q = qTable{node};
%% The format of E is: s a(maxq encoding) nr sp a_parent(maxq encoding)
state = E(:, 1:4);
primActions = E(:, 5);
rewards = E(:, 6);
nextStates = E(:, 7:10);
parentA = E(:, 11);

%% conver states to index
statesIdx = state2flat(state)+1;
nextStateIdx = state2flat(nextStates)+1;

%% Intialize variables
actionIdx = zeros(size(parentA));
numAction = size(Q, 2);
numSample = size(parentA, 1);
curATable = aTable(node,1:numAction); % the node name for action

%% Check if the node contains any subtask action as its direct children
containSubAction = sum(primActions - parentA) ~= 0;
figure(node);

nonNanMask = ones(numSample, 1);
%% Filter the experince table and locate relevant experience tuples
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
disp(['node ' num2str(node)  ' relevant ratio ' num2str(sum(nonNanMask)/numSample)]);

%% Begin value iteration
for i = 1:maxIter
    Q = qTable{node};
    originalQ = zeros(numSample,1);
    y = zeros(numSample, 1);
    
    for j = 1:numSample
        originalQ(j) = Q(statesIdx(j), actionIdx(j));
    end
    
    % if node contains subtask action
    if containSubAction   
        for j = 1:numSample
            % Skip irrevelant samples
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
        % this line can be merged to the above if block. But the current
        % way is faster because we can do matrix opeation for the entire
        % dataset
        y = rewards + gamma * max(Q(nextStateIdx, :), [], 2);
    end
    
    %% for each state, action pair, compute the emperical mean of Q_node(s, a)
    for j = 1:500
        for k = 1:numAction
            stateMask = statesIdx==j;
            actionMask = actionIdx==k;
            target = y(stateMask & actionMask & nonNanMask);
            if (~isempty(target))
                Q(j, k) = mean(target);
            else
                % this line is interesting, because we have to put a lower
                % value in those unvisited states, so that that unseen
                % action will not be trusted (executed)
                % This problem may goes away in the second (challenge)
                % setting because flat random policy will search the space
                % more evenly.
                Q(j, k) = -10;
            end
        end
    end
    qTable{node} = Q;
    plot(Q);
    drawnow
    
    %% compute bellman residual
    resd = mean(abs(y(nonNanMask) - originalQ(nonNanMask)));
    disp(['Iter '  num2str(i) ' node ' num2str(node) ' bellman residual is ' num2str(resd)]);
    if (resd < 0.01)
        break;
    end
end

%% evaluate the entire policy by 100 trials in the simulator
evalHSMQ(100, true);
end

