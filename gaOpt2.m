function gaOpt2

global Gene; Gene = []; % 基因信息
Gene.bits = 10;
Gene.series = [];
Gene.decode = 0;
Gene.max = 10;
Gene.min = 0;

global Sample; Sample = []; % 个体信息
Sample.loop = 0;
Sample.id = 0;
Sample.father = 0;
Sample.mother = 0;
Sample.geneAmount = 3;
Sample.genes = [];
Sample.fitness = 0;

global GA; GA = [];     % 进化过程
GA.require = 'max';     % 不可更改
GA.people = 10;         % 种群数量
GA.id = 0;              % 起始 ID 编号
GA.samples = [];        % 种群个体信息
GA.loop = 0;            % LOOP 次数，衍生代数
GA.father = Sample;     % 产生子个体过程中的父亲
GA.mother = Sample;     % 产生子个体过程中的母亲
GA.child = Sample;      % 产生的子代
GA.next =[];            % 下一次的迭代信息
GA.pro = 0.01;          % 基因突变比率

global History; History = []; % 进化史，每一代中的最优个体。

Initialize;
while GA.loop < 500
    GA.loop = GA.loop + 1;
    for j = 1:GA.people;
        Select;
        Born;
        Mutation;
        GA.next(j) = GA.child;
    end
    GA.samples = GA.next;
    Best;
    
    if max([ GA.samples.fitness ]) - min([ GA.samples.fitness ]) < 0.001;
        GA.pro = GA.pro * 1.01;
    end
end

plot( 1:length(History),[History.fitness] );

function y = TargetFunction( x )

y = 0.01 * x.^2 - 0.01 * x + sin(x) + 1;
% y = 300 - (x-5).^2;

y = sum(y);

function y = Fit( genes )

x = zeros( 1,length(genes) );
for i = 1:length(x);
    x(i) = genes(i).decode;
end

y = TargetFunction( x );

function Initialize

global Sample GA History;

EmptySample = Sample;
EmptySample(1) = [];
GA.samples = EmptySample;

for i = 1:GA.people;
    GA.samples(i).loop = GA.loop;
    GA.samples(i).id = SetNextId;
    GA.samples(i).father = 0;
    GA.samples(i).mother = 0;
    GA.samples(i).geneAmount = Sample.geneAmount;
    GA.samples(i).genes = CreateRandGenes;
    GA.samples(i).fitness = Fit(  GA.samples(i).genes );
end

GA.father = GA.samples(1);
GA.mother = GA.samples(1);
GA.child = GA.samples(1);
GA.next = GA.samples;

History = EmptySample;

function id = SetNextId

global GA; GA.id = GA.id + 1; id = GA.id;

function genes = CreateRandGenes

global Gene Sample;

genes = Gene; 
for i = 1:Sample.geneAmount;
    genes(i).bits = Gene.bits;
    genes(i).series = rand( 1,Gene.bits ) > 0.5;
    genes(i).decode = Decode( genes(i).series );
    genes(i).max = Gene.max;
    genes(i).min = Gene.min;
end

function v = Decode( series )

global Gene;

vbits = 2.^( 0:Gene.bits-1 );
x = sum( vbits( series ) );

MAX = sum( vbits );
MIN = 0;
v = (x - MIN) / MAX *( Gene.max - Gene.min ) + Gene.min;

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

global GA Sample;

for i = 1:Sample.geneAmount;
    if rand(1) > 0.5;
        GA.child.genes(i) = GA.father.genes(i);
    else
        GA.child.genes(i) = GA.mother.genes(i);
    end
end

GA.child.loop = GA.loop;
GA.child.id = SetNextId;
GA.child.father = GA.father.id;
GA.child.mother = GA.mother.id;
GA.child.geneAmount = Sample.geneAmount;
GA.child.fitness = Fit( GA.child.genes );


function Mutation

global Gene Sample GA; pro = GA.pro;

for i = 1:Sample.geneAmount;
    if rand(1) < pro;
        p = 0;
        while p < 1 || p > Gene.bits;
            p = floor( rand(1)*Gene.bits );
        end
        GA.child.genes(i).series(p) = ~GA.child.genes(i).series(p);
        GA.child.genes(i).decode = Decode( GA.child.genes(i).series );
        GA.child.fitness = Fit( GA.child.genes );
    end
end

function Best

global History GA;

best = GA.samples(1);
for i = 2:GA.people
    if GA.samples(i).fitness > best.fitness;
        best = GA.samples(i);
    end
end

History = [ History,best ];

