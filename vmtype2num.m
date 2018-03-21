function n = vmtype2num( vmtype )

global Input Process;
for i = 1:length( Input.vmReqs );
    if strcmp( vmtype,Input.vmReqs(i).type ); n = i; return; end
end

Process.error = true;
Process.errtype = 'Cannot find VM Type';
Process.errmsg = vmtype;
showError;

n = 0;
