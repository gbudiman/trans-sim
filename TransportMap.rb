require 'set'

class TransportMap < Hash
	def consolidate_edges
        self.each do |target, edge|
            edge["connects_to"].each do |connection|
                self.each do |source, inner_edge|
                    if connection == source
                        if inner_edge["connects_to"].add?(target)
                           puts "consolidated #{target} to #{source}"
                        end
                    end
                end
            end
        end
    end

    def clear_node(_name)
        self.delete(_name)
    end

    def connect_mock_node(_name, _locations)
        #self[_name]["connects_to"].merge(self[_location]["connects_to"])
        _locations.each do |location|
            self[_name]["connects_to"].merge(self[location]["connects_to"])
        end
    end

    def mock_node(_name, _type, _locations)
        self[_name] = {
            "connects_to"   => Set.new(_locations)   ,
            "type"          => _type                ,
            "length"        => 0
        }
        self.connect_mock_node(_name, _locations)
    end
end
