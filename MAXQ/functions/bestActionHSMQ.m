function [action] = bestActionHSMQ(node, sIdx)
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
if (node > 7 || node == 4 || node == 5)
    action = node;
else
    Q = qTable{node};
    tempQ = Q(sIdx, :);
    [~, maxIdx] = max(tempQ);
    a = aTable(node, maxIdx);
    action = bestActionHSMQ(a, sIdx); 
end


end

