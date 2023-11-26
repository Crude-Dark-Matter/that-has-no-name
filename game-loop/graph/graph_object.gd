class_name GraphObject
extends Object
# Base class for InteractionNode and CommandEdge objects, responsible for
# instantiating from parsed graph resources

var _name : String
# all id's are of format GRAPH.{n|e}.UNIQUE_INT
# where GRAPH can be a path with any number of subgraphs
# "graph_1.graph_2.graph_3.n.15" is a node
# "graph_1.graph_2.graph_3.e.15" is an edge
var _id : String
