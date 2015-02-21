process count=3;

#define acceptable_skew 10
#define max_skew 15
#define cProc 200

global synchronizer 
  u,
  c,
  r,
  f,
  ss; // 
  
global discrete
  clock_idle,
  counter_inco,
  counter_corr,
  clock_voted:0..cProc;
  
mode dispatcher(true){
  when ?f (true) may ; 
  when ?c (true) may ; 
  when ?u (true) may ;
  when ?r (true) may ;
}
  
mode client_idle(true){
  when !u (true) may goto client_syc_ing;
}

mode client_syc_ing(true){
  when ?ss(clock_voted<cProc) may clock_voted++1; clock_idle--1;
  when !c(clock_voted==cProc) may clock_idle=cProc; clock_voted=0; counter_inco=0; counter_corr=0; goto client_idle;
}

mode server(true){
  when !ss(clock_voted<cProc && (client_idle % Max_skew) > acceptable_skew) may counter_corr++1;
  when !ss(clock_voted<cProc ) may counter_inco++1;
}

initially 
    counter_inco==0
&&  counter_corr ==0
&&  clock_idle==cProc
&&  clock_voted==0
&&  dispatcher@(1) 
&&  client_idle@(2) 
&&  server@(3);

