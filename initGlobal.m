function initGlobal

% global VMreq Time Input VMpredict Output History Process;

global VMreq; VMreq = [];
VMreq.type = '';
VMreq.cpu = 0;
VMreq.memory = 0;

global Time; Time = [];
Time.year = 0;
Time.month = 0;
Time.day = 0;
Time.hour = 0;
Time.minute = 0;
Time.second = 0;

global Input; Input = [];

Input.serverCpu = 0;
Input.serverMemory = 0;
Input.serverRom = 0;
Input.vmTypes = 0;
Input.vmReqs = [];
Input.optType = ''; % MEM / CPU
Input.begin = Time;
Input.end = Time;

global VMpredict; VMpredict = [];
VMpredict.type = '';
VMpredict.amount = 0;

global Output; Output = [];
Output.cntVM = 0;
Output.vmPredict = [];
Output.cntServer = 0;
Output.distribution = {};

global History; History = [];
History.vmId = '';
History.vmType = '';
History.vmTime = [];
History(1) = [];

global Process; Process = [];
Process.error = false;
Process.errtype = '';
Process.errmsg = '';
