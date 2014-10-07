#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <string>
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

GraphNode* readModel(){


}


int main(int argc, char** argv){
    fstream infile,outfile;

    GraphNode* root=readModel();

    

}




int cplugin_proc(int module_index,int   proc_index) {
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