function plotByYear( selYear )

if nargin == 0; selYear = 0; end

global Input;

History = getHistory( selYear );
if isempty(History);
    data = [ ' ',num2str(selYear),' �� ' ];
else
    data = [ ' ',num2str(History(1).vmTime.year),' �� ' ];
end

if isempty(History);
    disp([ '������',data,'�����ݣ�' ]);
    return;
end

type = { History(1:end).vmType };
time = [ History(1:end).vmTime ];

month = [ time.month ];

ntype = zeros( 1,length(type) );
for i = 1:length(type); ntype(i) = vmtype2num( type{i} ); end

eachMonth = unique( month );


figure;
x = eachMonth;
y = x;
for i = 1:length(y);
    y(i) = length( find( month == x(i) ) );
end
bar( x,y );
title( [ '��',data,'��ÿ�µ��������������ֻ���������������' ]);
xlabel('�·�');
ylabel('����');

figure;
x = eachMonth;
y = x;
y(:) = 0;
for i = 1:length(y);
    current = month == x(i);
    currVMtype = ntype( current );
    for j = 1:length(currVMtype);
        if currVMtype(j) <= 0 || currVMtype(j) > length(Input.vmReqs);
            continue; end
        y(i) = y(i) + Input.vmReqs( currVMtype(j) ).cpu;
    end
end
bar( x,y );
title( [ '��',data,'��ÿ�µ� CPU ������' ]);
xlabel('�·�');
ylabel('����');

figure;
x = eachMonth;
y = x;
y(:) = 0;
for i = 1:length(y);
    current = month == x(i);
    currVMtype = ntype( current );
    for j = 1:length(currVMtype);
        if currVMtype(j) <= 0 || currVMtype(j) > length(Input.vmReqs);
            continue; end
        y(i) = y(i) + Input.vmReqs( currVMtype(j) ).memory;
    end
end
bar( x,y );
title( [ '��',data,'��ÿ�µ� MEM ������ / MB' ]);
xlabel('�·�');
ylabel('����');

function h = getHistory( y )

global History;

if ~isempty(History);
    if y == 0; y = History(1).vmTime.year; end
end

time = [ History.vmTime ];
y2 = [ time.year ];

h = History( y2 == y );
