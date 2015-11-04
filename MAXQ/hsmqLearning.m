% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).
% vTable: numS * numNode matrix
% cTable: numNode * 1 cell
% inside: numS * numA matrix
% aTable contains the avaliable action for node 1 2 3 6 7
global qTable
global aTable
global totalStep;

qTable = cell(11, 1);
qTable{1} = 0.123+zeros(500, 2); %root
qTable{2} = 0.123+zeros(500, 2); %get
qTable{3} = 0.123+zeros(500, 2); %put
qTable{6} = 0.123+zeros(500, 4); %put
qTable{7} = 0.123+zeros(500, 4); %put
%}
aTable = zeros(11, 6);
aTable(1, 1) = 2; %root
aTable(1, 2) = 3; %root
aTable(2, 1) = 4; %get
aTable(2, 2) = 6; %get
aTable(3, 1) = 5; %put
aTable(3, 2) = 7; %put
aTable(6, 1:4) = 8:11; %navi_get
aTable(7, 1:4) = 8:11; %navi_put
%}
maxIter = 6000;
evalStep = [];
evalAvgR = [];
stepCnt = 0;
initTemp = 100;
tempDecay = 0.98;
trainR = zeros(maxIter, 1);
evaInterval = 100;

%% The online HSMQ learning algorihtm
for i = 1:maxIter
    s = initStateGenerate();
    % decay T
    realTemp = initTemp * tempDecay ^ i;
    totalStep = 0;
    [sp, trainR(i), N]  = HSMQ(1, s, realTemp, 0);
    %evalAvgR(i) = R;
    stepCnt = stepCnt + N;
    if (mod(i, evaInterval) == 0)
        %avg = evalHSMQ(100);
        evalAvgR = [evalAvgR; mean(trainR(i-evaInterval+1:i))];
        evalStep = [evalStep; stepCnt];
        disp(['iter ' num2str(i) ' having ' num2str(evalAvgR(end)) ' with ' num2str(stepCnt)]);
    end
end

%% Plot the performance curve
plot(evalStep, evalAvgR);
