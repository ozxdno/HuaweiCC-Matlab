function fitLine

[ x,vm,cpu,memory ] = plotByStep3( ...
    '2015-01-01 00:00:00', ...
    '0000-00-07 00:00:00' );

%fit1( x,vm );
fit1( x,cpu );
%fit1( x,memory );

%fit2( x,vm );
fit2( x,cpu );
%fit2( x,memory );


function fit1( x,y )

throw = y == 0; x( throw ) = []; y( throw ) = [];
p = polyfit( x,y,1 );

figure; hold on;

plot( x,y,'*b' );
plot( x,p(1)*x+p(2),'r' );

function fit2( x,y )

throw = y == 0; x( throw ) = []; y( throw ) = [];
p = polyfit( x,y,2 );

figure; hold on;

plot( x,y,'*b' );
plot( x,p(1)*x.^2+p(2)*x+p(3),'r' );

