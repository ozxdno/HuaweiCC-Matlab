function x = comparePredictResult

clearHistory;
readText_History('TestData_2015.2.20_2015.2.27.txt');

x.type = ''; x.amount = 0;
for i = 1:15;
    x(i).type = [ 'flavor',num2str(i) ];
    x(i).amount = getVMAmount(x(i).type);
end


function n = getVMAmount( vmType )

global History;

n = length( find(strcmp({History.vmType},vmType)) );
