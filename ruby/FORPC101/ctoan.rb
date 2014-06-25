=begin
# Hi there
=end

require 'find'


# Example of blocks
def my_method
    puts "Start of my_method"
    yield
    yield
    puts "End of my_method"
end

my_method {puts 'In the block'}

# puts "Finding files and directories..."
# 
# Find.find('./') do |f|
    # type = case
           # when File.file?(f): "F"
           # when File.directory?(f): "D"
           # else "?"
           # end
    # puts "#{type}: #{f}"
# end
# 

puts number = -12.abs

# Example of case statement
mynum = 3
puts "Case statement example start."
case mynum
when 1
	puts "mynum is 1"
when 2
	puts "mynum is 2"
when 3, 5
	puts "mynum is 5"
end
puts "Case statement example end."

# Example of using inspect method
puts [ 1, 2, 3..4, 'five' ].inspect


# Example of using partition method
nums = [1,2,3,4,5,6,7,8,9]
odd_even = nums.partition {|x| x%2 ==1}
puts odd_even.inspect
puts odd_even

# Example of using any? method
nums.push(nil)
puts nums.inspect
# Are any of these numbers even?
flag = nums.any? {|x| x%2 ==0}
puts flag # true

flag1 =nums.any?
# list contains at least one true value
# (non-nil or non-false)
puts flag1 # true

# Example of showing all symbols
#puts Symbol.all_symbols

# Example of freezing an object, but then getting around it
# by creating a new object
str = 'Original String - '
str.freeze
puts 'str is frozen' if str.frozen?
str += 'attachment'
puts str
puts 'str is not frozen anymore' if (!str.frozen?)

class MyFoo
        MY_CONST = 10
end

myvar="MyFoo"
puts "Constant is #{MyFoo::MY_CONST}"
# puts "Constant is " + myvar::MY_CONST

mytime="2008:08:13 11:05:17|2008:08:13 11:53:23"
puts mytime[0...19]
conv_time = mytime[0...19].sub(/(\d{4}):(\d{2}):(\d{2})/, '\1/\2/\3')
puts "conv_time=#{conv_time}"

