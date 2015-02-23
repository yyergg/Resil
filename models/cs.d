process count=11;

#define acceptable_skew_avg 1
#define acceptable_skew 1
#define max_skew 1

global synchronizer 
  u,
  c,
  f,
  req,
  reply;

global discrete
  total_skew : 0..(#PS-2)*acceptable_skew;

global discrete
  clock_corr: 0..#PS-2;  

local discrete 
  local_skew
    : 0..max_skew;

mode dispatcher(true){
  when ?f (true) may ; 
  when ?c (true) may ; 
  when ?u (true) may ;
}
  
mode client_idle(true){
  when !u ?(#PS-2)req (true) may goto client_judge;
}

mode client_judge(true){
  when !f (clock_corr==0 || total_skew > acceptable_skew_avg*clock_corr) 
    may 
    total_skew=0; 
    clock_corr=0; 
    goto client_idle;
  when !c (clock_corr>0 && total_skew <= acceptable_skew_avg*clock_corr) 
    may 
    total_skew=0; 
    clock_corr=0; 
    goto client_idle;
}

mode server_idle(true){
  when !u (local_skew < max_skew) may local_skew = local_skew+1;
  when !c (local_skew > 0) may local_skew = local_skew-1;
  when !req(local_skew>acceptable_skew) may ;
  when !req(local_skew <= acceptable_skew) 
  may 
    total_skew=total_skew+local_skew; 
    clock_corr=clock_corr+1; 
}

initially 
    total_skew == 0
&& clock_corr==0
&&  dispatcher@(1) 
&&  client_idle@(2) 
&&  (forall k:3..#PS,(server_idle@(k) && local_skew@(k) == 1));