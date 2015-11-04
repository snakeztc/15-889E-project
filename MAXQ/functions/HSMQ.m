function [sp, R, N] = HSMQ(node, s, T, exe)
global qTable
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
%disp(['node ' num2str(node) ' state ' num2str(sIndex)]);
gamma = 0.96;
totalStep = totalStep + 1;
lr = 0.5;
if (node > 7 || node == 4 || node == 5)
    if (node > 7) 
        a = node -7;
    else
        a = node + 1;
    end    
    [sp, R, ~] = taxiEnv(s, a);
    N = 1;
    return;
end

N = 0;
R = 0;
B = 1;
while taxiMaxTermnial(s, node) ~= 1
    sIndex= state2flat(s)+1;
    Q = qTable{node};
    % give -inf for inactive node
    tempQ = Q(sIndex, :);
    allAs = aTable(node, :);
    for i = 1:size(Q,2)
        if (taxiMaxTermnial(s, allAs(i)) == 1)
            tempQ(i) = -inf;
        end
    end
    if (exe == 1)
         aIdx = boltzmanAction(tempQ, 0);
    else
        aIdx = boltzmanAction(tempQ, T);
    end
    a = allAs(aIdx);
    
    
    [sp, rp, np] = HSMQ(a, s, T/2, exe);
    spIdx = state2flat(sp) + 1;
    
    if (exe == 0)
        Q(sIndex, aIdx) = Q(sIndex, aIdx) ...
            + lr * (rp + gamma^np * max(Q(spIdx, :)) - Q(sIndex, aIdx));
        qTable{node} = Q;   
    end
    
    R = R + B*rp;
    B = B * gamma;
    N = N + np;
  
    s = sp;
    if (totalStep > 1000)
        break;
    end
end
sp = s;
end

