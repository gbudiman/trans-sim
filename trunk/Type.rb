load 'Utility.rb'

class Type
	def initialize _file
		u = Utility.new
		@type = u.load_spec _file
	end

	def set _name
		raise "NodeTypeUnknown" if @type[_name] == nil
		return @type[_name]
	end
end