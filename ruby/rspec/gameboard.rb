=begin
 gameboard
=end

class Gameboard
	attr_accessor :locations, :no_of_hits

	def initialize
		@locations = [0,0,0,0,0,0,0]
		@no_of_hits = 0
	end

	def set_locations_cells(arry)
		arry.each do |x|
			@locations[x] = 1
		end
		@locations
	end

	def check_yourself(guess)
		guess = guess.to_i
		if @locations[guess] == 1
			@locations[guess] = 0
			@no_of_hits += 1
			puts 'hit' if __FILE__ == $0
			return :hit if @locations.include?(1)
			return 'kill'
		else
			puts 'miss' if __FILE__ == $0
			return :miss
		end
	end
	
end
 
