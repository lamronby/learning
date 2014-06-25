=begin
 Program that converts Fahrenheit to Celsius

    * Begin by subtracting 32 from the Fahrenheit number.
    * Divide the answer by 9.
    * Then multiply that answer by 5.
  Example: Change 95 degrees Fahrenheit to Celsius: 
    95 minus 32 is 63. Then, 63 divided by 9 is 7. 
    Finally, 7 times 5 is 35 degrees Celsius. 
=end

def convert(fahrTemp)
    return(((fahrTemp.to_f-32)/9)*5)
end

puts "Enter the Fahrenheit temperature"
# STDOUT - global constant - the actual standard output stream for the program
# flush - flushes any buffered data within IO to the underlying operating system
STDOUT.flush

fahrTemp = gets.chomp
# puts "#{fahrTemp} degrees F = #{'%5.2f' % convert(fahrTemp)} degrees C"
puts "#{fahrTemp} degrees F = #{format('%.2f', convert(fahrTemp))} degrees C"


