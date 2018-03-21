function str = time2str( time )

year = num2str( time.year );
month = num2str( time.month );
day = num2str( time.day );
hour = num2str( time.hour );
minute = num2str( time.minute );
second = num2str( time.second );

if time.month < 10; month = [ '0',month ]; end
if time.day < 10; day = [ '0',day ]; end
if time.hour < 10; hour = [ '0',hour ]; end
if time.minute < 10; minute = [ '0',minute ]; end
if time.second < 10; second = [ '0',second ]; end

str = [ year,'-',month,'-',day,' ',hour,':',minute,':',second ];