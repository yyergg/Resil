process count=13;

global synchronizer 
  u,
  c,
  f;

global discrete
  crp,cfp: 0..6;

global discrete
  cfm,crm: 0..6;  

mode dispatcher(true){
  when ?f (true) may ; 
  when ?c (true) may ; 
  when ?u (true) may ;
}
  
mode prun(true){
  when !c (true) may;
  when !u (true) may crp=crp-1; cfp=cfp+1; goto pfaulty;
  when !c (true) may crp=crp-1; goto pidle;
}

mode pfaulty(true){
  when !c (true) may cfp=cfp-1; goto pidle;
}

mode pidle(true){
  when !c !fd (true) may goto pcopy;
  when !c (true) may crp=crp+1; goto prun;
}

mode pcopy(true){
  when !u (true) may;
  when !c !rs(true) may goto pidle;
}

mode mrun(true){
  when !c (true) may;
  when !u (true) may crm=crm-1; cfm=cfm+1; goto mfaulty;
  when !c (true) may crm=crm-1; goto midle;
}

mode mfaulty(true){
  when ?fd (true) may cfm=cfm-1; goto mcopy;
}

mode midle(true){
  when !c (true) may crm=crm+1; goto mrun;
}

mode mcopy(true){
  when !c (true) may;
  when ?rs(true) may goto midle;
}

initially 
    crp == 6
&& cfp==0
&& crm ==6
&& cfm == 0
&&  dispatcher@(1) 
&&  (forall k:2..7,prun@(k))
&&  (forall k:8..13,mrun@(k));