% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).
% vTable: numS * numNode matrix
% cTable: numNode * 1 cell
% inside: numS * numA matrix
% aTable contains the avaliable action for node 1 2 3 6 7
clear;
global vTable
global cTable
global aTable
global totalStep
global expTable

vTable = cell(11, 1);
vTable{4} = 0.123+zeros(500, 1); %pick
vTable{5} = 0.123+zeros(500, 1); %drop
vTable{8} = 0.123+zeros(500, 1); %up
vTable{9} = 0.123+zeros(500, 1); %down
vTable{10} = 0.123+zeros(500, 1); %left
vTable{11} = 0.123+zeros(500, 1); %right

cTable = cell(11, 1);
cTable{1} = 0.123+zeros(500, 2); %root
cTable{2} = 0.123+zeros(500, 2); %get
cTable{3} = 0.123+zeros(500, 2); %put
cTable{6} = 0.123+zeros(500, 4); %put
cTable{7} = 0.123+zeros(500, 4); %put

aTable = zeros(11, 6);
aTable(1, 1) = 2; %root
aTable(1, 2) = 3; %root
aTable(2, 1) = 4; %get
aTable(2, 2) = 6; %get
aTable(3, 1) = 5; %put
aTable(3, 2) = 7; %put
aTable(6, 1:4) = 8:11; %navi_get
aTable(7, 1:4) = 8:11; %navi_put

expTable = cell(11, 1);

maxIter = 1000;
trainR = zeros(maxIter, 1);
evalAvgR = [];
evalStep = [];
evaInterval = 100;
stepCnt = 0;
initTemp = 100;
% previous set to 0.9939
tempDecay = 0.98;
col = 0;
exe = 0;


%% For data collection
states = [];
nextStates = [];
actions = [];
rewards = [];


for i = 1:maxIter
    s = initStateGenerate();
    localCnt = 0;
    localR = 0;
    % decay T
    realTemp = initTemp * tempDecay ^ i;
    totalStep = 0;
    [sp, trainR(i), N, chSeq, chAct, chR] = maxqzero(1, s, realTemp, exe, col);
    if col == 1
        % save all the data
        states = [states; [s; chSeq(1:end-1, :)]];
        nextStates = [nextStates; chSeq];
        actions = [actions; chAct];
        rewards = [rewards; chR];
    end
    stepCnt = stepCnt + N; 
    %disp(['Step with ' num2str(stepCnt)]);
    if (mod(i, evaInterval) == 0)
        %avgR = maxqEval(100);
        evalAvgR = [evalAvgR; mean(trainR(i-evaInterval+1:i))];
        evalStep = [evalStep; stepCnt];
        disp(['iter ' num2str(i) ' having ' num2str(evalAvgR(end)) ' with ' num2str(stepCnt)]);
    end
end
%plot(evalStep, evalAvgR);
%save('maxQR-states.mat', 'states');
%save('maxQR-nextStates.mat', 'nextStates');
%save('maxQR-actions.mat', 'actions');
%save('maxQR-rewards.mat', 'rewards');
%save('maxQR-expTable.mat', 'expTable');
