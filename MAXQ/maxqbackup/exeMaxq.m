function [ N, sp, R, totalCnt] = exeMaxq(node, s, vTable, cTable, aTable, totalCnt)
% this function is designed just work for taxi
% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), up(8), down(9), left(10), right(11).
%
% vTable: numS * numNode matrix
% cTable: numNode * 1 cell
% inside: numS * numA matrix
% aTable contains the avaliable action for node 1 2 3 6 7
sIndex= state2flat(s)+1;
%disp(['in node ' num2str(node) ' with state ' num2str(sIndex) ' steps ' num2str(totalCnt)]);
if (node > 7 || node == 4 || node == 5)
    if (node > 7) 
        a = node - 7;
    else
        a = node + 1;
    end    
    [sp, R, ~] = taxiEnv(s, a);
    N = 1;
    totalCnt = totalCnt + 1;
    return;
end
N = 0;
R = 0;
totalCnt = totalCnt + 1;
while taxiMaxTermnial(s, node) ~= 1 && totalCnt < 1000
    sIndex= state2flat(s)+1;
    C = cTable{node};
    allAs = aTable(node, 1:size(C, 2));
    tempV = zeros(1, size(C, 2));
    for j = 1:size(C, 2)
        tempV(j) = evalMaxNode(allAs(j), s, vTable, cTable, aTable);
    end
    tempC = C(sIndex, :);
    %aIdx = boltzmanAction(tempC+tempV, 1);
    [~, aIdx] = max(tempV + tempC);
    a = aTable(node, aIdx);
    [np, sp, rp, totalCnt] = exeMaxq(a, s, vTable, cTable, aTable, totalCnt);
    s = sp;
    N = N + np;
    R = R + rp;
end
sp = s;
end

