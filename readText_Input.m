function readText_Input( path,name )

if nargin == 0; path = '';
    name = 'Input.txt'; end
if nargin == 1; name = path;
    path = '';
end

global Input Process VMreq;

full = name; if ~isempty(path); full = [ path,'\',name ]; end
Fid = fopen( full );
rowStart = 1;
row = 0;
part = 0;
head = true;

while feof(Fid) == 0;
    line = textscan( Fid ,'%s',1,'delimiter','\n' );
    vars = cutString( line{1}{1},' ' );
    row = row + 1;
    
    if head && isempty(vars);
        rowStart = rowStart + 1;
        continue;
    end
    if head && ~isempty(vars);
        head = false;
    end
    
    if part == 0;
        if row - rowStart == 0;
            if length(vars) ~= 3;
                setError1(row);
                return;
            end
            Input.serverCpu = str2double(vars{1});
            Input.serverMemory = str2double(vars{2});
            Input.serverRom = str2double(vars{3});
            if isempty(Input.serverCpu) || isnan( Input.serverCpu );
                setError1(row); return; end
            if isempty(Input.serverMemory) || isnan( Input.serverMemory );
                setError1(row); return; end
            if isempty(Input.serverRom) || isnan( Input.serverRom );
                setError1(row); return; end
            continue;
        end
        if row - rowStart == 1;
            if ~isempty(vars);
                setError1( row );
                return;
            end
            part = part + 1;
            rowStart = row + 1;
            continue;
        end
        setError1( row );
        return;
    end
    if part == 1;
        if row - rowStart == 0;
            if length(vars) ~= 1; setError1( row ); return; end
            Input.vmTypes = str2double(vars{1});
            if isempty(Input.vmTypes) || isnan(Input.vmTypes);
                setError1( row ); return;
            end
            continue;
        end
        if row - rowStart > 0;
            if isempty(vars);
                part = part + 1;
                rowStart = row + 1;
                continue;
            end
            if length(vars) ~= 3; 
                setError1( row );
                return;
            end
            if isempty( Input.vmReqs );
                Input.vmReqs = VMreq;
            else
                Input.vmReqs(length(Input.vmReqs)+1) = VMreq;
            end
            Input.vmReqs(end).type = vars{1};
            Input.vmReqs(end).cpu = str2double(vars{2});
            Input.vmReqs(end).memory = str2double(vars{3});
            if isempty(Input.vmReqs(end).cpu) || isnan(Input.vmReqs(end).cpu);
                setError1( row ); return;
            end
            if isempty(Input.vmReqs(end).memory) || isnan(Input.vmReqs(end).memory);
                setError1( row ); return;
            end
            continue;
        end
    end
    if part == 2;
        if row - rowStart == 0;
            if length(vars) ~= 1; setError1( row ); return; end
            if ~strcmp( vars{1},'CPU' ) && ~strcmp( vars{1},'MEM' );
                setError1( row ); return; end
            Input.optType = vars{1};
            continue;
        end
        if row - rowStart == 1;
            if ~isempty(vars); setError1( row ); return; end
            part = part + 1;
            rowStart = row + 1;
            continue;
        end
        setError1( row );
        return;
    end
    if part == 3;
        if row - rowStart == 0;
            Input.begin = str2time(line{1}{1});
            if Process.error; return; end
            continue;
        end
        if row - rowStart == 1;
            Input.end = str2time(line{1}{1});
            if Process.error; return; end
            continue;
        end
        return;
    end
end
fclose( Fid );

function vars = cutString( str,char )

vars = {};
while ~isempty(str)
    pos = 0;
    for i = 1:length(str);
        if str(i) == char; pos = i; break; end
    end
    if pos == 0; vars = [ vars,str ]; return;end
    if pos > 1; vars = [ vars,str(1:pos-1) ]; end
    str = str(pos+1:end);
end

function setError1( row )

global Process;

Process.errtype = 'Input File Content is Wrong !';
Process.errmsg = [ 'at line : ',num2str(row) ];
Process.error = true;

showError;

