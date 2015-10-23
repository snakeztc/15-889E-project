function [N, sp] = maxqzero(node, s, T)
global vTable
global cTable
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
sIndex= state2flat(s)+1;
%disp(['in node ' num2str(node) ' with state ' num2str(sIndex)]);
gamma = 0.95;
lr = 0.25;
if (node > 7 || node == 4 || node == 5)
    if (node > 7) 
        a = node -7;
    else
        a = node + 1;
    end    
    V = vTable{node};
    [sp, r, ~] = taxiEnv(s, a);
    V(sIndex) = (1-lr)*V(sIndex) + lr * r;
    vTable{node} = V;
    N = 1;
    return;
end
N = 0;
while taxiMaxTermnial(s, node) ~= 1
    sIndex= state2flat(s)+1;
    C = cTable{node};
    numActions = size(C, 2);
    allAs = aTable(node, 1:numActions);
    tempV = zeros(1, numActions);
    for j = 1:numActions
        tempV(j) = policyMaxNode(allAs(j), s, vTable, cTable, aTable, T);
    end
    tempC = C(sIndex, :);
    aIdx = boltzmanAction(tempC+tempV, T);
    a = aTable(node, aIdx);

    [np, sp] = maxqzero(a, s, T);
    
    C(sIndex, aIdx) = (1-lr)*C(sIndex, aIdx) + lr * gamma^np * ...
        evalMaxNode(node, sp);
    cTable{node} = C;
    N = N + np;
    s = sp;
end
sp = s;
end

