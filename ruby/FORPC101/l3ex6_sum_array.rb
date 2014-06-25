=begin
 Exercise6. Write a Ruby program (p020arraysum.rb) that, when given an array as collection = [1, 2, 3, 4, 5] it calculates the sum of its elements.
=end

puts [1, 2, 3, 4, 5].inject {|sum, elem| sum+=elem}
puts [6, 7, 8, 9, 10].inject {|sum, elem| sum+=elem}



