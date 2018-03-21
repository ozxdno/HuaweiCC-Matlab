function [ x,vm, cpu,memory ] = plotByStep3( begin,step )

% begin ��ʼʱ�䣬�磺2015-01-01 00:00:00
% step��ͳ�Ʋ������磺0000-00-01 00:00:00 ����ʾ����Ϊһ�죩
% 
% plotByStep( '2015-01-01 00:00:00','0000-00-01 00:00:00' )

if ischar(begin); begin = str2time( begin ); end
if ischar(step); step = str2time( step ); end
if later( str2time('0000-00-00 00:00:01'),step );
    disp(' ');
    disp('Error: ������С��')
    disp( ['step = ',time2str(step)] );
    disp(' ');
    return;
end

global Input Process;
History = getHistory;

x = 1:1000;
vm = x; vm(:) = 0;
cpu = x; cpu(:) = 0;
memory = x; memory(:) = 0;
item = 1;

s_vm = 0;
s_cpu = 0;
s_memory = 0;

next = tplus( begin,step );
tEnd = tplus( History(end).vmTime,step );
cnt = 0;
while later( tEnd,next ) && cnt < length( History )
    % disp( length( History ) - cnt );
    cnt = cnt + 1;
    curr = History(cnt).vmTime;
    if earlier( curr,next );
        x(item) = item;
        type = vmtype2num( History(cnt).vmType );
        if Process.error; clearError; continue; end
        
        vm(item) = vm(item) + 1;
        cpu(item) = cpu(item) + Input.vmReqs(type).cpu;
        memory(item) = memory(item) + Input.vmReqs(type).memory;
        
%         s_vm = s_vm + 1;
%         s_cpu = s_cpu + Input.vmReqs(type).cpu;
%         s_memory = s_memory + Input.vmReqs(type).memory;
%         
%         vm(item) = s_vm;
%         cpu(item) = s_cpu;
%         memory(item) = s_memory;
    else
        next = tplus( next,step );
        item = item + 1;
        cnt = cnt - 1;
    end
end

x = x( 1:item );
vm = vm( 1:item );
cpu = cpu( 1:item );
memory = memory( 1:item );

figure;
plot( x,vm,'*-' );
title( '�����������' );
xlabel( 'ʱ���' );
ylabel( '����' );

% figure;
% bar( x,cpu );
% title( ' CPU ������' );
% xlabel( 'ʱ���' );
% ylabel( '����' );
% 
% figure;
% bar( x,memory );
% title( ' MEM ������' );
% xlabel( 'ʱ���' );
% ylabel( '����' );

function h = getHistory

global History;

vmtypes = { History.vmType };
ntypes = zeros( 1,length(vmtypes) );

for i = 1:length(vmtypes);
    ntypes(i) = vmtype2num( vmtypes{i} );
end

h = History( ntypes == 11 );
