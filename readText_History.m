function readText_History( path,name )

if nargin == 0; path = '';
    name = 'History.txt'; end
if nargin == 1; name = path;
    path = '';
end

full = name; if ~isempty(path); full = [ path,'\',name ]; end
Fid = fopen( full );
row = 0;

global History Process;

while feof(Fid) == 0;
    line = textscan( Fid ,'%s',1,'delimiter','\n' );
    vars = cutString( line{1}{1},{ ' ',9 } );
    row = row + 1;
    
    if isempty(vars); continue; end
    if length(vars) ~= 4; setError1( row ); return; end
    
    History( length(History)+1 ).vmId = vars{1};
    History(end).vmType = vars{2};
    History(end).vmTime = str2time( [ vars{3},' ',vars{4} ] );
    if Process.error; return; end
end
fclose( Fid );

function vars = cutString( str,chars )

vars = {};
while ~isempty(str)
    pos = 0;
    for i = 1:length(str);
        for j = 1:length(chars);
            if str(i)+1 == chars{j}+1; pos = i; break; end
        end
        if pos ~= 0; break; end
    end
    if pos == 0; vars = [ vars,str ]; return;end
    if pos > 1; vars = [ vars,str(1:pos-1) ]; end
    str = str(pos+1:end);
end

function setError1( row )

global Process;

Process.errtype = 'History File Content is Wrong !';
Process.errmsg = [ 'at line : ',num2str(row) ];
Process.error = true;

showError;
