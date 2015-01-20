process count=2;
global synchronizer u,c,f,r;

mode dispatcher(true){
  when !c (true) may;
  when !u (true) may;
  when !f (true) may;
}

mode node_1(true){
  when ?c (true) may goto node_1;
  when ?u (true) may goto node_2;
}
mode node_2(true){
  when ?c (true) may goto node_1;
  when ?c (true) may goto node_2;
  when ?u (true) may goto node_3;
}
mode node_3(true){
  when ?c (true) may goto node_2;
  when ?c (true) may goto node_3;
  when ?f (true) may goto node_4;
}
mode node_4(true){
}

initially
   dispatcher@(1)
&& node_1@(2);
