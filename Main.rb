load 'Node.rb'
load 'Type.rb'
load 'Utility.rb'
require 'pp'

t = Type.new 'spec.xls'

u = Utility.new.load_map 'TestMap.xls'
pp u