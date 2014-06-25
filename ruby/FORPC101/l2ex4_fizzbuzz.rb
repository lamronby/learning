=begin
 Exercise4. Write a Ruby program that prints the numbers from 1 to 100. But for multiples of three print "Fizz" instead of the number and for the multiples of five print "Buzz". For numbers which are multiples of both three and five print "FizzBuzz".
=end

# Lots of different ways to do the loop
x = 1
#while (x <= 100) do
# 100.times do |x|
#1.step(100, 1) {|x|
1.upto(100) do |x|
    outstr = case
             when (x % 3 == 0) && (x % 5 == 0) then "FizzBuzz"
             when x % 3 == 0 then "Fizz"
             when x % 5 == 0 then "Buzz"
             else x
             end
    puts outstr
    x += 1
end    

