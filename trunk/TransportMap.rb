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
end
