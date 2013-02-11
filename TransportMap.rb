require 'set'

class TransportMap < Hash
    def initialize
        self.set_short_commute
    end

    def set_short_commute
        @maximum_cost = 900
    end

    def set_medium_commute 
        @maximum_cost = 3600
    end

    def set_long_commute
        @maximum_cost = 21600
    end

    def set_overnight_commute
        @maximum_cost = 86400
    end

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
        _locations.each do |location|
            self[_name]["connects_to"].merge(self[location]["connects_to"])
        end
    end

    def mock_node(_name, _type, _locations)
        self[_name] = {
            "connects_to"   => Set.new(_locations)  ,
            "type"          => _type                ,
            "class"         => 'Node'               ,
            "length"        => 0
        }
        self.connect_mock_node(_name, _locations)
    end

    def find_path(_start, _goal)
        @closed_set = Set.new
        @open_set = Set.new
        @came_from = Hash.new
        @g_score = Hash.new
        @f_score = Hash.new

        @open_set.add(_start)
        @g_score[_start] = 0
        @f_score[_start] = @g_score[_start] + @maximum_cost

        while !@open_set.empty?
            @current = @f_score.keys.sort_by{ |k, v| v }.first

            puts @current
            if @current == _goal
                reconstruct_path(_goal)
            end

            @open_set.delete @current
            @closed_set.add @current 

            self[@current]['connects_to'].each do |neighbor|
                puts "-> #{neighbor}"
                if @closed_set.include? neighbor
                    next
                end

                tentative_g_score = @g_score[@current] +
                    self[@current]['length']

                if !@open_set.include? neighbor or
                        tentative_g_score < @g_score[neighbor]
                    @came_from[neighbor] = @current
                    @g_score[neighbor] = tentative_g_score
                    @f_score[neighbor] = @g_score[neighbor] +
                        (@maximum_cost - self[@current]['length'])
                    if !@open_set.include? neighbor
                        @open_set.add neighbor
                    end
                end
            end

            return false
        end
    end

    def reconstruct_path(current_node)
        if @came_from.include? current_node
            p = reconstruct_path current_node
            return p + current_node
        else
            return current_node
        end
    end
end
