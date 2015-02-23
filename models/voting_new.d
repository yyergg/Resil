// This is the counter abstraction of a voting algorithm
process count=3;

#define CProc 26
global synchronizer
    u, 
    c, 
    f, 
    corr, 
    inco, 
    req;  

global discrete
    count_fault,  
    count_fault_to_reply,
    count_run_to_reply,
    count_run,  
    count_corr, 
    count_inco 
    :0..CProc;

mode dispatcher(true){
    when ?c (true) may ;
    when ?f (true) may ;
    when ?u (true) may ;
}


mode client_idle (true) {
    when !u !req (true) 
        may count_corr = 0; count_inco = 0; goto client_wait;
} 

mode client_wait (true) { 
    when !c (count_corr > (CProc/2))
        may count_corr = 0; count_inco = 0; goto client_corr;
    when !f (count_inco > (CProc/2))
        may count_corr = 0; count_inco = 0; goto client_inco;
} 

mode client_corr (true) {
    when !u (true) may goto client_idle;
}

mode client_inco (true) {
    when !u (true) may goto client_idle;
}

mode server_idle (true) {
    when !u (count_run > 0 && count_fault < CProc)
        may count_run--1; count_fault++1;
    when !c (count_run < CProc && count_fault > 0)
        may count_run++1; count_fault--1;
    when !u (count_run_to_reply > 0 && count_fault_to_reply < CProc) 
        may count_run_to_reply--1; count_fault_to_reply++1;  
    when !c (count_run_to_reply < CProc && count_fault_to_reply > 0) 
        may count_run_to_reply++1; count_fault_to_reply--1;  
    when ?req (true)
        may 
        count_corr = count_run;
        count_inco = count_fault;
        count_fault_to_reply = count_fault_to_reply + count_fault;
        count_run_to_reply = count_run_to_reply + count_run;
        goto server_op;
} 

mode server_op (true) {
    when !c (count_run == 0 && count_fault == 0)
        may
        count_run = count_run_to_reply;
        count_run_to_reply = 0;
        count_fault = count_fault_to_reply;
        count_fault_to_reply = 0;
        goto server_idle;
}


initially
    count_fault == 0
&&  count_run == CProc
&&  count_run_to_reply == 0
&&  count_corr == 0
&&  count_inco == 0
&&  dispatcher@(1)
&&  client_idle@(2)
&&  server_idle@(3);
