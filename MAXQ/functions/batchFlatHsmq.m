function  batchFlatHsmq(node,expTable)
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
maxIter = 50;
gamma = 0.95;
verbose = 0;

%E = expTable{node};
E = expTable;
Q = qTable{node};
%% The format of E is: s a(maxq encoding) nr sp a_parent(maxq encoding) 
% we will ignore parentA for the flatHsmq case
state = E(:, 1:4);
primActions = E(:, 5);
rewards = E(:, 6);
nextStates = E(:, 7:10);
%parentA = E(:, 11);

primActions = encodingConvert(primActions, 'flat');

%% convert states to index
statesIdx = state2flat(state)+1;
nextStateIdx = state2flat(nextStates)+1;

%% Intialize variables
numAction = size(Q, 2);
numSample = size(state, 1);
curATable = aTable(node,1:numAction); % the node name for action

%% Check if the node contains any subtask action as its direct children
if (verbose == 1)
    figure(node);
end

nonNanMask = ones(numSample, numAction);
%% Filter the experince table and locate relevant experience tuples
for i = 1:numSample
    for j = 1:numAction
        % create valid mask
        curPrimA = primActions(i);
        bestA = f(curATable(j), statesIdx(i));
        if (bestA ~= curPrimA)
            nonNanMask(i, j) = 0;
        end
    end
end
nonNanMask = logical(nonNanMask);
% calculate what percentage data is useful in learning this node's policy
if (verbose)
    disp(['node ' num2str(node)  ' relevant ratio ' num2str(sum(sum(nonNanMask, 2)>0)/numSample)]);
end

%% Begin value iteration
for i = 1:maxIter
    Q = qTable{node};
    originalQ = zeros(numSample,numAction);
    y = zeros(numSample, numAction);
    
    % find the intial q values for all actions before Bellman backup
    for j = 1:numSample
        for k = 1:numAction
            originalQ(j, k) = Q(statesIdx(j), k);
        end
    end
    
    % if node contains subtask action
    for j = 1:numSample
        for k = 1:numAction
            % Skip irrevelant samples
            if (~nonNanMask(j, k))
                continue;
            end
            if taxiMaxTermnial(nextStates(j, :), node)
                y(j, k) = rewards(j);
            else                
                if taxiMaxPrimitve(curATable(k)) || taxiMaxTermnial(nextStates(j, :), curATable(k))
                    y(j, k) = rewards(j) + gamma * max(Q(nextStateIdx(j), :));
                else
                    y(j, k) = rewards(j) + gamma * Q(nextStateIdx(j), k);
                end
            end
        end
    end
    
    %% for each state, action pair, compute the emperical mean of Q_node(s, a)
    for j = 1:500
        for k = 1:numAction
            stateMask = statesIdx==j;
            target = y(stateMask & nonNanMask(:, k), k);
            if (~isempty(target))
                Q(j, k) = mean(target);
            else
                % this line is interesting, because we have to put a low
                % value in those unvisited states, so that that unseen
                % action will not be trusted (executed)
                % This problem may goes away in the second (challenge)
                % setting because flat random policy will search the space
                % more evenly.
                %Q(j, k) = -10;
            end
        end
    end
    qTable{node} = Q;
    if (verbose == 1)
        plot(Q);
        drawnow
    end
    
    %% compute bellman residual
    resd = mean(abs(y(nonNanMask) - originalQ(nonNanMask)));
    if (verbose)
        disp(['Iter '  num2str(i) ' node ' num2str(node) ' bellman residual is ' num2str(resd)]);
    end
    if (resd < 0.001)
        break;
    end
    %}
end

%% evaluate the entire policy by 100 trials in the simulato
if (verbose == 1)
    evalHSMQ(100, true);
end
end

