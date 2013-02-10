require 'set'

class Utility
	def initialize
		return self
	end

	def load_spec _file
		require 'spreadsheet'
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet.open _file
		sheet = book.worksheet 0

		header_row = sheet.row 0
		return false unless header_row[0] == 'Name' &&
			header_row[1] == 'Type'

		for i in 1..10
			break if sheet.row(i)[0] != nil
			raise 'EmptySheet' if i == 10
		end

		type_hash = Hash.new
		while sheet.row(i)[0] != nil do
			row = sheet.row(i)
			type_hash[row[0]] = {
				"name"			=> row[1]						,
				"type"			=> row[2]						,
				"fixed_cost"	=> row[3] 		|| 0			,
				"variable_cost"	=> Float(row[4] || 0) / 3600	,
				"fixed_fee"		=> row[5] 		|| 0			,
				"variable_fee"	=> 
					(row[6] || 0) == 0 ? 0 : Float(1) / row[6]	,
				"congestion"	=> row[7]
			}
			i += 1
		end

		return type_hash
	end

	def load_map _file
		load 'TransportMap.rb'
		require 'spreadsheet'
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet.open _file
		sheet = book.worksheet 0

		header_row = sheet.row 0
		return false unless header_row[0] == 'Edge ID' &&
			header_row[1] == 'Connects To'

		for i in 1..4
			break if sheet.row(i)[0] != nil
			raise 'EmptySheet' if i == 4
		end

		map_hash = TransportMap.new
		while sheet.row(i)[0] != nil do
			row = sheet.row(i)
			map_hash[row[0]] = {
				"connects_to"	=> row[1].split(/,\s*/).to_set	,
				"type"			=> row[2]						,
				"length"		=> row[3] || 0
			}
			i += 1
		end

		return map_hash.consolidate_edges
	end
end
