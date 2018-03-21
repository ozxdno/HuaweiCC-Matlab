function ox = sameTime( t1,t2 )

ox = true;

if t1.year ~= t2.year; ox = false; return; end
if t1.month ~= t2.month; ox = false; return; end
if t1.day ~= t2.day; ox = false; return; end
if t1.hour ~= t2.hour; ox = false; return; end
if t1.minute ~= t2.minute; ox = false; return; end
if t1.second ~= t2.second; ox = false; return; end