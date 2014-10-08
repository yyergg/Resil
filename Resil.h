#include <string>
#include <vector>
using namespace::std;


class GraphNode;
class GraphEdge;

class GraphNode{
    string name;
    vector<bool> labels;
    vector<GraphEdge*> inEdges;
    vector<GraphEdge*> outEdges;
};

class GraphEdge{
    int type;
    GraphNode* src;
    GraphNode* dst;
};
