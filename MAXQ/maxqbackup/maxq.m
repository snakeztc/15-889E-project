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

maxIter = 1000;
evalAvgR = [];
stepCnt = 0;
initTemp = 50;
tempDecay = 0.9996;
for i = 1:maxIter
    pass = randi(4);
    dest = randi(4);
    car = randi(5, 2, 1)';
    s = [dest, pass, car];
    localCnt = 0;
    localR = 0;
    % decay T
    realTemp = initTemp * tempDecay ^ i;
    if realTemp < 5
        realTemp = 5;
    end
    [nn, ss] = maxqzero(1, s, realTemp);
    
    stepCnt = stepCnt + nn;
    
    %disp(['Step with ' num2str(stepCnt)]);
    if (mod(i, 10) == 0)
        avgR = maxqEval(vTable, cTable, aTable, 10);
        evalAvgR = [evalAvgR; avgR];
        disp(['iter ' num2str(i) ' having ' num2str(avgR) ' with ' num2str(stepCnt)]);
    end
end
