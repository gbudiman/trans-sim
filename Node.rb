class Node
	def initialize(_id, 
			_type, 
			_connects_to = Array.new)
		@id = _id
		@type = _type
		@connects_to = _connects_to
	end
end