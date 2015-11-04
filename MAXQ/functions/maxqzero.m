function [sp, R, N, chSeq, chAct, chR] = maxqzero(node, s, T, exe, col)
global vTable
global cTable
global aTable
global totalStep
global expTable
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
if nargin < 5
    col = 0;
end
gamma = 0.96;
lr = 0.5;
chSeq = [];
chAct = [];
chR = [];
totalStep = totalStep + 1;
if (node > 7 || node == 4 || node == 5)
    sIndex= state2flat(s)+1;
    if (node > 7) 
        a = node -7;
    else
        a = node + 1;
    end    
    [sp, R, ~] = taxiEnv(s, a);
    if exe == 0
        V = vTable{node};
        V(sIndex) = (1-lr)*V(sIndex) + lr * R;
        vTable{node} = V;
    end
    N = 1;
    chSeq = [chSeq;sp];
    chAct = [chAct; node];
    chR = [chR; R];
    return;
end

N = 0;
B = 1;
R = 0;
E =  expTable{node};
while taxiMaxTermnial(s, node) ~= 1
    sIndex= state2flat(s)+1;
    C = cTable{node};
    numActions = size(C, 2);
    allAs = aTable(node, 1:numActions);
    tempV = zeros(1, numActions);
    for i = 1:numActions
        if (taxiMaxActive(s, allAs(i)) == 0 || taxiMaxTermnial(s, allAs(i)) == 1)
            tempV(i) = -inf;
        else 
            tempV(i) = evalMaxNode(allAs(i), s, T);
        end
    end
    tempC = C(sIndex, :);
    if exe == 1
        aIdx = boltzmanAction(tempC+tempV, 0);
    else
        aIdx = boltzmanAction(tempC+tempV, T);
    end
    a = allAs(aIdx);

    [sp, rp, np, nseq, nact, nr] = maxqzero(a, s, T/2, exe, col);
    
    if col == 1
         % save the experience for batch learning
        % s, a, n, sp tuple
        %tuple = [[s; nseq(1:end-1,:)] repmat(a, np, 1) (np:-1:1)' repmat(sp, np, 1)];
        % s a(primitive encoding) r np sp a_parent (maxq encoding)
        tuple = [[s; nseq(1:end-1,:)] nact nr nseq repmat(a, np, 1)];
        %tuple = [s a np sp];
        E = [E; tuple];
    end
    
    if (exe == 0)
        evalSp = evalMaxNode(node, sp, 0); %greedy
        C(sIndex, aIdx) = (1-lr)*C(sIndex, aIdx) + lr * gamma^np * evalSp;
        %{
        nseqIdx = state2flat(nseq)+1;  
        for i = 1:np-1
            C(nseqIdx(i), aIdx) = (1-lr)*C(nseqIdx(i), aIdx) + lr * gamma^(np-i) * evalSp;
        end
        %}
        cTable{node} = C;
    end
    chSeq = [chSeq; nseq];
    chAct = [chAct; nact];
    chR = [chR; nr];
    R = R + B * rp;
    B = B * gamma;
    N = N + np;
    s = sp;
    if (totalStep > 1000)
        break;
    end
end
sp = s;
if col == 1
    expTable{node} = E;
end
end

