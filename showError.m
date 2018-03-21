function error = showError

global Process; 

error = Process.error; if ~Process.error; return; end
disp( ' ' );
disp( [ 'Error: ', Process.errtype ] );
disp( Process.errmsg );
disp( ' ' );
