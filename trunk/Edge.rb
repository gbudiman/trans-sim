class Edge
	def initialize(_id,
			_type,
			_connects_to = Array.new)
		@id = id
		@type = type
		@connects_to = _connects_to
	end
end