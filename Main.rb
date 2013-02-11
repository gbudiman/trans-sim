load 'Node.rb'
load 'Type.rb'
load 'Utility.rb'
require 'pp'

t = Type.new 'spec.xls'
m = Utility.new.load_map('TestMap.xls', t)

m.mock_node('source', 'lambda', ['A1'])
m.mock_node('target', 'lambda', ['E5'])
m.consolidate_edges

m.find_path('source', 'target')