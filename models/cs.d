process count=17;

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
  when !u (true) may goto client_judge;
}

mode client_judge(true){
  when !f ( (local_skew@(3)+local_skew@(4)+local_skew@(5)+local_skew@(6)
    +local_skew@(7)+local_skew@(8)+local_skew@(9)+local_skew@(10)+local_skew@(11)
    +local_skew@(12)+local_skew@(13)+local_skew@(14)+local_skew@(15))==(#PS-2)*acceptable_skew) 
    may goto client_idle;
  when !c ( (local_skew@(3)+local_skew@(4)+local_skew@(5)+local_skew@(6)
    +local_skew@(7)+local_skew@(8)+local_skew@(9)+local_skew@(10)+local_skew@(11)
    +local_skew@(12)+local_skew@(13)+local_skew@(14)+local_skew@(15)) < (#PS-2)*acceptable_skew) 
    may goto client_idle;
}

mode server_idle(true){
  when !u (local_skew < max_skew) may local_skew = local_skew+1;
  when !c (local_skew > 0) may local_skew = local_skew-1;
}

initially 
  dispatcher@(1) 
&&  client_idle@(2) 
&&  (forall k:3..#PS,(server_idle@(k) && local_skew@(k) == 1));