function bestFit( target )

s = size( target ); if s(2) ~= 1; target = target'; end
bagSolution( target )

function solution = bagSolution( target )

global Input;

Bag.content = 0;
Bag.value = 0;
Bag.items = zeros( 1,length(target) );

if strcmp( Input.optType,'CPU');
    Bag.content = Input.serverCpu;
end
if strcmp( Input.optType,'MEM');
    Bag.content = Input.serverMemory;
end

cnt = 0; Servers = Bag;
while sum( target ) > 0; cnt = cnt + 1;
    Servers(cnt) = Bag;
    Putin = zeros( 1,Bag.content+1 );
    for i = length(target):-1:1
        for j = 1:target(i);
            c = Input.vmReqs(i).cpu;
            m = Input.vmReqs(i).memory;
            for k = Bag.content:-1:c;
                w = Input.vmReqs(i).cpu;
                v = w;
                if Putin(k-w+1) + v > Putin(k+1);
                    Putin(k+1) = Putin(k-w+1) + v;
                    Servers(cnt).items(i) = Servers(cnt).items(i) + 1;
                end
            end
        end
    end
    Servers(cnt).value = Putin( end );
    target = target - Servers(cnt).items;
end

solution = Servers;

