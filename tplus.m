function t = tplus( t0, t )

v = t0.second + t.second;
b = 0;
if v >= 60; b = 1; v = v - 60; end
t.second = v;

v = t0.minute + t.minute + b;
b = 0;
if v >= 60; b = 1; v = v - 60; end
t.minute = v;

v = t0.hour + t.hour + b;
b = 0;
if v >= 24; b = 1; v = v - 24; end
t.hour = v;

v = t0.day + t.day + b;
b = 0;
if any( [1,3,5,7,8,10,12] == t0.month );
    if v > 31; b = 1; v = v - 31; end
    t.day = v;
end
if any( [4,6,9,11] == t0.month );
    if v > 30; b = 1; v = v - 30; end
    t.day = v;
end
if t0.month == 2;
    if mod( t0.year,4 ) == 0;
        if v > 29; b = 1; v = v - 29; end
    else
        if v > 28; b = 1; v = v - 28; end
    end
    t.day = v;
end

v = t0.month + t.month + b;
b = 0;
if v > 12; b = 1; v = v - 12; end
t.month = v;

v = t0.year + t.year + b;
t.year = v;
