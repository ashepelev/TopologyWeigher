import BandwidthHistory
import Scheduler

__author__ = 'ash'


import yaml

import GraphDrawer

import TrafficGen

stream_nodes = file('topology-examples/nodes1.yaml','r')
stream_edges = file('topology-examples/edges1.yaml','r')

node_list = yaml.load(stream_nodes)
edge_list = yaml.load(stream_edges)

bwhist = BandwidthHistory.BandwidthHistory(node_list,edge_list)
trgen = TrafficGen.TrafficGen(node_list,bwhist)

trgen.generator()

stream_nodes.close()
stream_edges.close()

dist = Scheduler.Scheduler.build_distances(bwhist)
task = Scheduler.Task.example_task()

print "Appropriate node: " + str(Scheduler.Scheduler.schedule(dist,task,node_list))

gr = GraphDrawer.GraphDrawer(node_list,edge_list)
graph = gr.get_edges()
labels = gr.get_labels()
gr.draw_graph(graph,labels=labels, graph_layout='spring',draw_bandwidth='avg')

exit()