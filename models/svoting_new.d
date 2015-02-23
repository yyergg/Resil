process count=3;
#define clientCount 250
global synchronizer 
  u, // uncontrollable 0
  c, // controllable 1
  f, // fault detection
  vote, // incorrect ballot from the fault processors
  req;  // request by the client to vote. 

global discrete 
  count_fault, 
  count_run, 
  count_corr, 
  count_inco 
  :0..clientCount;

mode dispatcher(true){
  when !c (true) may ;
  when !f (true) may ; 
  when !u (true) may ;
}

mode client_check (true) { 
  when ?u (count_corr > (clientCount/2)) 
    may count_corr = 0; count_inco = 0; goto client_corr;     
  when ?f (count_inco > (clientCount/2)) 
    may count_corr = 0; count_inco = 0; goto client_inco;     
}

mode client_wait (true) { 
  when ?vote (true) 
    may goto client_check; 
} 

mode client_idle (true) { 
  when ?u !req (true) 
    may count_corr = 0; count_inco = 0; goto client_wait; 
} 

mode client_corr (true) { 
  when ?u (true) may goto client_idle; 
} 

mode client_inco (true) { 
  when ?u (true) may goto client_idle; 
} 

mode server_idle (true) {
  when ?u (count_run > 0 && count_fault < clientCount) 
    may count_run--1; count_fault++1;  
  when ?c (count_run < clientCount && count_fault > 0) 
    may count_run++1; count_fault--1;  

  when ?req (true) 
    may goto server_op; 
} 

mode server_op (true) { 
  when ?u (count_run > 0 && count_fault < clientCount) 
    may count_run--1; count_fault++1;  
  when ?c (count_run < clientCount && count_fault > 0) 
    may count_run++1; count_fault--1;  

  when ?c !vote (true) 
    may count_inco = count_fault; count_fault = 0; 
      count_corr = count_run; count_run = 0; 
      goto server_idle; 
}

initially 
    count_fault == 0
&&  count_run == clientCount
&&  count_corr == 0 
&&  count_inco == 0 
&&  dispatcher@(1)
&&  client_idle@(2) 
&&  server_idle@(3);
