=begin
 Understand the differences between empty string and nil and how they
 can be checked in a conditional statement.
=end

var=nil

if (var)
	puts "Var, when nil, is true"
else
	puts "Var, when nil, is not true"
end

puts "Var, when nil, is nil" if (var == nil)
	
puts "Var, when nil, is false" if (!var)

var=''

puts "Var is empty string" if (var == '')
	

if (var)
	puts "Var, when an empty string, is true"
else
	puts "Var, when an empty string, is not true"
end

puts "Var, when an empty string, is nil" if (var == nil)
	

puts "Var, when an empty string, is false" if (!var)
	

