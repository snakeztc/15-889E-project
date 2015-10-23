% node index: root(1), get(2), put(3), pick(4), drop(5),
% navi_get(6), navi_put(7), north(8), east(9), south(10), west(11).
% vTable: numS * numNode matrix
% cTable: numNode * 1 cell
% inside: numS * numA matrix
% aTable contains the avaliable action for node 1 2 3 6 7
global qTable
global aTable

qq = importdata('optimalHSMQselfQTable.mat');
Qmin = 0.123;
qTable = cell(11, 1);
qTable{1} = Qmin+zeros(500, 2); %root
qTable{2} = Qmin+zeros(500, 2); %get
qTable{3} = Qmin+zeros(500, 2); %put
qTable{6} = Qmin+zeros(500, 4); %put
qTable{7} = Qmin+zeros(500, 4); %put
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


%% Intialize subroutine nodes
Q2 = qTable{2};
for i = 1:500
    if(taxiMaxTermnial(state2flat(i-1), 6))
        Q2(i, 2) = -inf;
    end
end
qTable{2} = Q2;

Q3 = qTable{3};
for i = 1:500
    if(taxiMaxTermnial(state2flat(i-1), 7))
        Q3(i, 2) = -inf;
    end
end
qTable{3} = Q3;

Q1 = qTable{1};
for i = 1:500
    if(taxiMaxTermnial(state2flat(i-1), 2))
        Q1(i, 1) = -inf;
    end
    if(taxiMaxTermnial(state2flat(i-1), 3))
        Q1(i, 2) = -inf;
    end
end
qTable{1} = Q1;

evalHSMQ(100, true);
%% Learn subroutinue
batchHsmq(6, expTable);
batchHsmq(7, expTable);
batchHsmq(2, expTable);
batchHsmq(3, expTable);
batchHsmq(1, expTable);

%% Compare qTables
Q2 = qTable{2};
Q2(Q2 == -inf) = Qmin;
disp(['q2 norm difference ' num2str(norm(max(Q2, [], 2) - max(qq{2}, [], 2)))]);

Q3 = qTable{3};
Q3(Q3 == -inf) = Qmin;
disp(['q3 norm difference ' num2str(norm(max(Q3, [], 2) - max(qq{3}, [], 2)))]);

Q1 = qTable{1};
Q1(Q1 == -inf) = Qmin;
disp(['q1 norm difference ' num2str(norm(max(Q1, [], 2) - max(qq{1}, [], 2)))]);









