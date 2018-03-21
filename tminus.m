function t = tminus( t0,t )

v = t0.second - t.second;
b = 0;
if v < 0; b = 1; v = 60 + v; end
t.second = v;

v = t0.minute - t.minute - b;
b = 0;
if v < 0; b = 1; v = v + 60; end
t.minute = v;

v = t0.hour - t.hour - b;
b = 0;
if v < 0; b = 1; v = v + 24; end
t.hour = v;

v = t0.day - t.day - b;
b = 0;
if v < 0; b = 1;
    if any( t0.month-1 == [1,3,5,7,8,10,12] );
        v = v + 31;
    end
    if any( t0.month-1 == [4,6,9,11] );
        v = v + 30;
    end
    if t0.month-1 == 2;
        if mod( t0.year,4 ) == 0;
            v = v + 29;
        else
            v = v + 28;
        end
    end
end
t.day = v;

v = t0.month - t.month - b;
b = 0;
if v < 0; v = v + 12; end
t.month = v;

v = t0.year - t.year - b;
t.year = v;

