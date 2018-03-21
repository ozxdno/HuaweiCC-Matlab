function t = str2time( s )

t = [];

p1 = find( s == '-' );
p2 = find( s == ' ' );
p3 = find( s == ':' );

if length(p1) ~= 2; setError1( s ); return; end
if length(p2) ~= 1; setError1( s ); return; end
if length(p3) ~= 2; setError1( s ); return; end

data = str2double( s(1:p1(1)-1) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.year = data;

data = str2double( s(p1(1)+1:p1(2)-1) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.month = data;

data = str2double( s(p1(2)+1:p2-1) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.day = data;

data = str2double( s(p2+1:p3(1)-1) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.hour = data;

data = str2double( s(p3(1)+1:p3(2)-1) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.minute = data;

data = str2double( s(p3(2)+1:end) );
if isempty(data) || isnan(data); setError1( s ); return; end
t.second = data;

function setError1( msg )

global Process;
Process.error = true;
Process.errtype = 'string to time struct';
Process.errmsg = msg;

showError;
