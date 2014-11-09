#include <string>
#include <vector>
using namespace::std;


class GraphNode;
class GraphEdge;

class GraphNode{
public:
    string name;
    bool isFail;
    vector<bool> labels;
    vector<GraphEdge*> inEdges;
    vector<GraphEdge*> outEdges;
};

class GraphEdge{
public:
    int type;
    GraphNode* src;
    GraphNode* dst;
};
