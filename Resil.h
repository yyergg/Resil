#ifndef RESIL_H
#define RESIL_H

#include<string>
#include<vector>
using namespace::std;
extern "C"{
  #include"redcplugins.e"
  #include"redlib.h"
  #include"redlib.e"
}

class GraphNode;
class GraphEdge;

class GraphNode{
public:
  int index;
  string name;
  redgram red;
  bool isFail;
  vector<bool> labels;
  vector<GraphEdge*> ins;
  vector<GraphEdge*> outs;
};

class GraphEdge{
public:
  int index;
  int type;
  int sxi;
  vector<string> synchronizers;
  GraphNode* src;
  GraphNode* dst;
};

#endif
