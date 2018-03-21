function plotByMonth( selYear,selMonth )

if nargin == 0; selYear = 0; selMonth = 0; end
if nargin == 1; selMonth = selYear; selYear = 0; end

global Input;

History = getHistory( selYear,selMonth );
if isempty(History);
    data = [ ' ',num2str(selYear),' �� ',num2str(selMonth),' ��' ];
else
    data = [ ' ',num2str(History(1).vmTime.year),' �� ', ...
        num2str(History(1).vmTime.month),' ��' ];
end

if isempty(History);
    disp([ '������',data,'�����ݣ�' ]);
    return;
end

type = { History(1:end).vmType };
time = [ History(1:end).vmTime ];

day = [ time.day ];

ntype = zeros( 1,length(type) );
for i = 1:length(type); ntype(i) = vmtype2num( type{i} ); end

eachDay = unique( day );


figure;
x = eachDay;
y = x;
for i = 1:length(y);
    y(i) = length( find( day == x(i) ) );
end
bar( x,y );
title( [ '��',data,'�У�ÿ����������������ֻ���������������' ]);
xlabel('����');
ylabel('����');

figure;
x = eachDay;
y = x;
y(:) = 0;
for i = 1:length(y);
    current = day == x(i);
    currVMtype = ntype( current );
    for j = 1:length(currVMtype);
        if currVMtype(j) <= 0 || currVMtype(j) > length(Input.vmReqs);
            continue; end
        y(i) = y(i) + Input.vmReqs( currVMtype(j) ).cpu;
    end
end
bar( x,y );
title( [ '��',data,'�У�ÿ��� CPU ������' ]);
xlabel('����');
ylabel('����');

figure;
x = eachDay;
y = x;
y(:) = 0;
for i = 1:length(y);
    current = day == x(i);
    currVMtype = ntype( current );
    for j = 1:length(currVMtype);
        if currVMtype(j) <= 0 || currVMtype(j) > length(Input.vmReqs);
            continue; end
        y(i) = y(i) + Input.vmReqs( currVMtype(j) ).memory;
    end
end
bar( x,y );
title( [ '��',data,'�У�ÿ��� MEM ������ / MB' ]);
xlabel('����');
ylabel('����');

function h = getHistory( y,m )

global History;

if ~isempty(History);
    if y == 0; y = History(1).vmTime.year; end
    if m == 0; m = History(1).vmTime.month; end
end

time = [ History.vmTime ];
y2 = [ time.year ];
m2 = [ time.month ];

h = History( (y2 == y) & (m2 == m) );
