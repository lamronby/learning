=begin
 Exercise2. Run the following two programs and try and understand the difference in the outputs of the two programs. The program:
=end

def mtdarry1
 10.times do |num|
    puts num
 end
end

puts "Method 1"
mtdarry1


def mtdarry2
 10.times do |num|
    puts num
 end
end

puts "Method 2"
puts mtdarry2

# In the second case, the puts is printing the result of the mtdarry2 call.
# The result is the "return value" of the 10.times call, which apparently is 10.
# Demonstrated by this example:

def mtdarry3
    15.times do |num|
    end
end

puts mtdarry3


