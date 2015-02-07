process count = 6;

//(#PS-2-1)/3
#define BOUND_FAULT 1

global synchronizer 
  c, 
  u, 
  f,
  request,
  reply_good,
  reply_bad,
  reply_corr,
  reply_inco; 

global discrete 
  count_corr,
  count_inco
    :0..#PS;

local discrete 
  count_good,
  count_bad
    : 0..#PS;

mode dispatcher (true) { 
  when ?f (true) may ;
  when ?c (true) may ; 
  when ?u (true) may ; 
} 

mode client_idle (true) { 
  when !u ?(#PS - 2)request (true) 
    may count_corr = 0; count_inco = 0; goto client_waiting; 
}

mode client_waiting (true) { 
  when !u ?reply_corr (true) may count_corr = count_corr + 1;
  when !u ?reply_inco (true) may count_inco = count_inco + 1; 
  when !u (count_corr + count_inco == (#PS - 2) && count_corr > BOUND_FAULT + 1) may goto client_corr; 
  when !f (count_corr + count_inco == (#PS - 2) && count_corr < BOUND_FAULT + 1) may goto client_inco; 
} 

mode client_corr (true) { 
  when !u (true) may count_corr = 0; count_inco = 0; goto client_idle; 
} 

mode client_inco (true) { 
  when !u (true) may count_corr = 0; count_inco = 0; goto client_idle; 
}

mode node_idle (true) {
  when !request (true) may goto node_prepare;
}

mode node_prepare (true) {
  when !c !(#PS - 3)reply_good (true) may count_good = count_good + 1; goto node_commit;
  when !u !(#PS - 3)reply_bad (true) may goto node_bad_commit;
  when ?reply_good (true) may count_good = count_good + 1;
  when ?reply_bad (true) may count_bad = count_bad + 1;
}

mode node_commit (true) {
  when ?reply_good (true) may count_good = count_good + 1;
  when ?reply_bad (true) may count_bad = count_bad + 1;
  when !u !reply_corr (count_good + count_bad == (#PS - 2) && count_good >= (2*BOUND_FAULT + 1)) may goto node_idle;
  when !u !reply_inco (count_good + count_bad == (#PS - 2) && count_good < (2*BOUND_FAULT + 1)) may goto node_idle;
} 

mode node_bad_commit (true) {
  when !u !reply_inco (true) may goto node_idle;
}

initially 
    count_corr ==0
&&  count_inco ==0
&&  dispatcher@(1) 
&&  client_idle@(2)
&&  (forall k:3..#PS,(node_idle@(k) && count_good@(k) == 0 && count_bad@(k) == 0));