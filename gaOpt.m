function gaOpt

global Sample; Sample = []; % 个体信息
Sample.id = 0;
Sample.father = 0;
Sample.mother = 0;
Sample.gen = [];
Sample.fitness = 0;
Sample.loop = 0;
Sample.para = [];

global Gene; Gene = []; % 基因信息
Gene.bits = 0;
Gene.series = [];
Gene.decode = 0;

global GA; GA = []; % 进化过程
GA.target = @TargetFunc;
GA.fit = @Fit;
GA.require = 'max'; % 不可更改
GA.people = 10;
GA.gbit = 30;
GA.samples = Sample; GA.samples( GA.people ) = Sample;
GA.loop = 0;
GA.father = Sample;
GA.mother = Sample;
GA.child = Sample;
GA.next = GA.samples;
GA.best = Sample;

x = 1:1000;
y = x;

InitSample;
while GA.loop < 1000  %|| SameDegree < 95
    GA.loop = GA.loop + 1;
    for j = 1:GA.people;
        Select;
        Born;
        Mutation;
        GA.next(j) = GA.child;
        GA.next(j).id = j;
        GA.next(j).loop = GA.loop;
    end
    GA.samples = GA.next;
    Best;
    y( GA.loop ) = GA.best.fitness;
    % disp(GA.loop);
end

plot( x,y );


function y = TargetFunc( x )

% x = [ 0,10 ];
% min or max

y = 0.01 * x.^2 - 0.01 * x + sin(x) + 1;
y = sum(y);

function y = Fit( gen )

global GA;

vbits = 2.^( 0:9 );

x(1) = sum( vbits( gen(01:10) ) );
x(2) = sum( vbits( gen(11:20) ) );
x(3) = sum( vbits( gen(21:30) ) );

MIN = 0;
MAX = sum( vbits );

x = (x - MIN) ./ (MAX - MIN) * 10;
y = GA.target(x);
function d = SameDegree

global GA;

std = GA.samples(1).gen;
same = 0;
for i = 2:GA.people;
    cnt = length( find( GA.samples(i).gen == std ) );
    same = same + cnt / GA.gbit;
end
d = same / ( GA.people-1 ) * 100;
function g = Encode( x )
function x = Decode( gen )

vbits = 2.^( 0:9 );

x(1) = sum( vbits( gen(01:10) ) );
x(2) = sum( vbits( gen(11:20) ) );
x(3) = sum( vbits( gen(21:30) ) );

MIN = 0;
MAX = sum( vbits );

x = (x - MIN) ./ (MAX - MIN) * 10;

function InitSample

global GA;

for i = 1:GA.people;
    GA.samples(i).gen = rand(1,GA.gbit) > 0.5;
    GA.samples(i).fitness = GA.fit( GA.samples(i).gen );
    GA.samples(i).loop = 0;
    GA.samples(i).para = Decode( GA.samples(i).gen );
    GA.samples(i).id = i;
    GA.samples(i).father = 0;
    GA.samples(i).mother = 0;
end
function Select

global GA Sample;

sumfit = sum( [ GA.samples.fitness ] );
average = sumfit / GA.people;
possible = Sample;
possible(1) = [];
for i = 1:GA.people;
    if GA.samples(i).fitness >= average;
        possible = [ possible,GA.samples(i) ];
    end
end

sumfit = sum( [ possible.fitness ] );
posfit = 0;
target = rand(1) * sumfit;
for i = 1:length(possible)
    if posfit <= target && target < posfit + possible(i).fitness;
        GA.father = possible(i);
        break;
    end
    posfit = posfit + possible(i).fitness;
end

posfit = 0;
target = rand(1) * sumfit;
for i = 1:length(possible)
    if posfit <= target && target < posfit + possible(i).fitness;
        GA.mother = possible(i);
        break;
    end
    posfit = posfit + possible(i).fitness;
end
function Born

global GA;

p = 0;
while p <= 1 || p >= GA.gbit;
    p = floor( rand(1)*GA.gbit );
end

geneA = GA.father.gen( 01:10 );
geneB = GA.father.gen( 11:20 );
geneC = GA.father.gen( 21:30 );
if rand(1) > 0.5; geneA = GA.mother.gen( 01:10 ); end
if rand(1) > 0.5; geneB = GA.mother.gen( 11:20 ); end
if rand(1) > 0.5; geneC = GA.mother.gen( 21:30 ); end

GA.child.gen = [ geneA,geneB,geneC ];

GA.child.fitness = GA.fit( GA.child.gen );
GA.child.para = Decode( GA.child.gen );
GA.child.father = GA.father.id;
GA.child.mother = GA.mother.id;
function Mutation

global GA;

pro = 0.01;
if rand(1) < pro;
    p = 0;
    while p < 1 || p > GA.gbit;
        p = floor( rand(1)*GA.gbit );
    end
    GA.child.gen(p) = ~GA.child.gen(p);
    GA.child.fitness = GA.fit( GA.child.gen );
    GA.child.para = Decode( GA.child.gen );
end
function Best

global GA;
GA.best = GA.samples(1);
for i = 2:GA.people
    if GA.samples(i).fitness > GA.best.fitness;
        GA.best = GA.samples(i);
    end
end

function DispResult

global GA;

vbits = 2.^( 0:9 );
x(1) = sum( vbits( GA.best.gen( 01:10 ) ) );
x(2) = sum( vbits( GA.best.gen( 11:20 ) ) );
x(3) = sum( vbits( GA.best.gen( 21:30 ) ) );

MIN = 0;
MAX = sum( vbits );

x = (x - MIN) ./ (MAX - MIN) * 10;
disp ' ';
disp( [ 'result = ',num2str(x) ] );
disp ' ';

