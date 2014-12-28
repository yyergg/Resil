#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <cstring>
#include <sstream>
#include <map>
#include "Resil.h"
using namespace::std;

extern "C"{
  #include "redcplugins.e"
  #include "redlib.h"
  #include "redlib.e"
}

map<string, GraphNode*> mapNode;
redgram path;
vector<GraphNode*> nodes;
vector<GraphEdge*> edges;
int nodeCount = 0;
int sxiCount = 0;


void printGameGraph(){
  int i,j,k;
  for(i=0;i<nodes.size();i++){
    cout<<i<<": "<<red_diagram_string(nodes[i]->red)<<endl;
    for(j=0;j<nodes[i]->outs.size();j++){
      cout<<"[";
      /*
      for(k=0;k<nodes[i]->outs[j]->selectionArray.size();k++){
        cout<<nodes[i]->outs[j]->selectionArray[k];
        if(k<nodes[i]->outs[j]->selectionArray.size()-1){cout<<",";}
      }
      */
      cout<<"]-->"<<red_diagram_string(nodes[nodes[i]->outs[j]->dst->index]->red)<<endl;
    }
  }
}


/*
vector<GraphNode*> intersection(vector<GraphNode*> graph1, vector<GraphNode*> graph2){
  int i,j;
  vector<GraphNode*> newGraph;
  for(i=0;i<graph1.size();i++){
    for(j=0;j<graph2.size();j++){
      if(graph1[i]==graph2[j]){
        newGraph.push_back(graph1[i]);
      }
    }
  }
  return newGraph;
}

 
vector<GraphNode*> sfrch_k(vector<GraphNode*> graph, vector<bool> riskLabel, int edgeType){
  int i;
  vector<GraphNode*> L;
  for(i=0;i<k+1;i++){
    next_L(L);
  }
  return sfrch_0(intersection(graph,L));
}

void sfrch_0(vector<GraphNode*> graph, vector<bool> riskLabel, int edgeType){

}

void cone(){

}

void frag(){

}

void next_L(vector<GraphNode*> &L){

}

void readModel(char* infileName, vector<GraphNode*> &Nodes, vector<GraphEdge*> &Edges){
  red_begin_session(RED_SYSTEM_TIMED, argv[1], -1); 
    //-1 == default(process number)
  red_input_model(argv[1], RED_REFINE_GLOBAL_INVARIANCE);
  red_set_sync_bulk_depth(10); 
    //number of transitions can be involve into a synchronize transition
  TCL_Game_Node* root;
  root=new TCL_Game_Node;
  root->index= nodeCount;
  root->red=red_query_diagram_initial();  
  //Initial root for the model
  
  Nodes.push_back(root);  nodeCount++;
  node_map[temp_string.assign(red_diagram_string(root->red))]=root->index;
  //Add root into list
    
  path=red_query_diagram_enhanced_global_invariance();
  sxiCount=red_query_sync_xtion_count(RED_USE_DECLARED_SYNC_XTION); 
  //number of synchronize transitions in the model
}
*/

void extractModelFromFile(GraphNode* root){
//  cout<<root->index<<": "<<red_diagram_string(root->red)<<endl;
  int i;
  string tempString;
  for(i=1;i<sxiCount;i++){
    redgram tempRed=red_sync_xtion_fwd(
      root->red,
      path,
      RED_USE_DECLARED_SYNC_XTION,
      i,
      RED_GAME_MODL | RED_GAME_SPEC | RED_GAME_ENVR,
      RED_TIME_PROGRESS,
      RED_NORM_ZONE_CLOSURE,
      RED_NO_ACTION_APPROX,
      RED_REDUCTION_INACTIVE,
      RED_NOAPPROX_MODL_GAME | RED_NOAPPROX_SPEC_GAME
      | RED_NOAPPROX_ENVR_GAME | RED_NOAPPROX_GLOBAL_GAME,
      RED_NO_SYMMETRY,
      0);
    if(red_and(tempRed, path) != red_false()){
      GraphEdge* tempEdge = new GraphEdge;
      GraphNode* tempNode;
      edges.push_back(tempEdge);
      tempEdge->sxi = i;
      if(mapNode.find(tempString.assign(red_diagram_string(tempRed))) == mapNode.end()){
        tempNode = new GraphNode;
        tempEdge->src = root;
        tempEdge->dst = tempNode;
        root->outs.push_back(tempEdge);
        tempNode->index = nodes.size() + 1; 
        tempNode->red = tempRed;
        tempNode->ins.push_back(tempEdge);
        nodes.push_back(tempNode);
        mapNode[tempString.assign(red_diagram_string(tempRed))] = tempNode;
//        cout<<root->index<<"--"<<i<<"-->"<<tempNode->index<<endl;
        extractModelFromFile(tempNode);
      }
      else{
        tempNode = mapNode[tempString.assign(red_diagram_string(tempRed))];
        tempEdge = new GraphEdge;
        tempEdge->src = root;
        tempEdge->dst = tempNode;
        root->outs.push_back(tempEdge);
        tempNode->ins.push_back(tempEdge);
//        cout<<root->index<<"--"<<i<<"-->"<<tempNode->index<<endl;
      }
    }
  }
}


void labelSynchronizers(){
  int i, j, k;
  cout<<"p="<<red_query_process_count()<<endl;
  for(i=0;i<edges.size();i++){
    cout<<i<<" "<<edges[i]->sxi<<endl;
    vector<string> synchronizers;
    for(j=0;j<red_query_process_count();j++){
      synchronizers.push_back("-");
    }
    for(j=0;j<red_query_sync_xtion_party_count(RED_USE_DECLARED_SYNC_XTION,edges[i]->sxi);j++){
      int p = red_query_sync_xtion_party_process(RED_USE_DECLARED_SYNC_XTION,edges[i]->sxi,j);
      int xi = red_query_sync_xtion_party_xtion(RED_USE_DECLARED_SYNC_XTION,edges[i]->sxi,j);
      cout<<p<<","<<xi<<" "<<red_query_xtion_attribute(xi, RED_XTION_SYNC_COUNT)<<" ";
      synchronizers[p-1] = red_query_xtion_attribute(xi, RED_XTION_SYNC_COUNT);
    }
    cout<<endl;
  }
}


int main(int argc, char** argv){
  int i, j;


  red_begin_session(RED_SYSTEM_TIMED, argv[1], -1); 
    //-1 == default(process number)
  red_input_model(argv[1], RED_REFINE_GLOBAL_INVARIANCE);
  red_set_sync_bulk_depth(10); 
    //number of transitions can be involve into a synchronize transition
  path = red_query_diagram_enhanced_global_invariance();
  sxiCount = red_query_sync_xtion_count(RED_USE_DECLARED_SYNC_XTION);

  GraphNode* root = new GraphNode;
  root->red = red_query_diagram_initial();
  root->index = 0;
  nodes.push_back(root);
  mapNode[red_diagram_string(root->red)] = root;

  extractModelFromFile(root);
  labelSynchronizers();
  //printGameGraph();
}

int cplugin_proc(int module_index, int proc_index) {
  switch(module_index) {
  case 1:
    break;
  case 2:
    break;
  case 3:
    switch (proc_index) {
    case 1:
      break;
    case 2:
      break;
    case 3:

      break;
    default:
      fprintf(RED_OUT, "\nCPLUG-INs module %1d: Illegal proc index %1d.\n",
        module_index, proc_index
      );
      fflush(RED_OUT);
      exit(0);
    }
    break;
  default:
    fprintf(RED_OUT,
      "\nCPLUG-INs: Illegal module index %1d.\n", module_index
    );
    fflush(RED_OUT);
    exit(0);
  }
}
