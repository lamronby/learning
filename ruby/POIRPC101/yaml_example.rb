#
# yaml_example
#

require 'yaml' 
require 'game_character.rb'   

def game_character_to_s(gc)
	s = gc.power.to_s + ', ' + gc.type + ': '   
	gc.weapons.each do |w|
		s += w + ' '
	end
	s
end

if __FILE__ == $0
	gc = GameCharacter.new(120, 'Magician', ['spells', 'invisibility'])
	puts 'gc object: ' + game_character_to_s(gc)   
	
	# Write the object.
	open("gc", "w") { |f| YAML.dump(gc, f) }

	# Read the object back in.
	data = open("gc") { |f| YAML.load(f) }
	
	puts 'data object: ' + game_character_to_s(data)   
end 

