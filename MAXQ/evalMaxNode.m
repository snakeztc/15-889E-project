function [value, action] = evalMaxNode(node, s, T)
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
V = vTable{node};
C = cTable{node};
if (node > 7 || node == 4 || node == 5)
    value = V(sIndex);
    action = node;
else
    numActions = size(C, 2);
    allAs = aTable(node, 1:numActions);
    tempV = zeros(1, numActions);
    for i = 1:numActions
        if (taxiMaxActive(s, allAs(i)) == 0 || taxiMaxTermnial(s, allAs(i)) == 1)
            tempV(i) = -inf;
        else 
            tempV(i) = evalMaxNode(allAs(i), s, T/2);
        end
    end
    Q = tempV + C(sIndex, :);
    aIdx = boltzmanAction(Q, T);
    value = Q(aIdx);
    action = aTable(node, aIdx);
end
end

