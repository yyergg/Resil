#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <string>
#include <sstream>
#include "Resil.h"
using namespace::std;

extern "C"{
  #include "redcplugins.e"
  #include "redlib.h"
  #include "redlib.e"
}
 
void greatestFixedPoint(vector<GraphNode*> graph, vector<bool> riskLabel, int edgeType){

}

void leastFixedPoint(vector<GraphNode*> graph, vector<bool> riskLabel, int edgeType){

}

void readModel(char* infileName, vector<GraphNode*> &Nodes, vector<GraphEdge*> &Edges){
  fstream infile;
  int i;
  int numNormalNode, numFailNode, numEdge;
  infile.open(infileName, ios::in);
  infile >> numNormalNode >> numFailNode >> numEdge;
  
  for(i=0;i<numNormalNode;i++){
    string s;
    stringstream ss(s);
    ss << i;
    GraphNode* newNode = new GraphNode();
    newNode -> name = ss.str();
    newNode -> isFail = false;
    Nodes.push_back(newNode);
  }

  for(i=numNormalNode;i<numNormalNode+numFailNode;i++){
    string s;
    stringstream ss(s);
    ss << i;
    GraphNode* newNode = new GraphNode();
    newNode -> name = ss.str();
    newNode -> isFail = true;
    Nodes.push_back(newNode);
  }

  for(i=0;i<numEdge;i++){
    int indexSrc,indexDst,type;
    infile>> indexSrc >> indexDst >> type;
    GraphEdge* newEdge = new GraphEdge();
    newEdge -> src = Nodes[indexSrc];
    newEdge -> dst = Nodes[indexDst];
    newEdge -> type = type;
    Edges.push_back(newEdge);
  }

  infile.close();
}

int main(int argc, char** argv){
  int i,j;
  vector<GraphNode*> Nodes;
  vector<GraphEdge*> Edges;
  readModel(argv[1], Nodes, Edges);


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
