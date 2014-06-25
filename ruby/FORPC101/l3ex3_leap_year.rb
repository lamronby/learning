=begin
 Exercise3. Write a Ruby program (p016leapyear.rb) that asks for a year and then displays to the user whether the year entered by him/her is a leap year or not.
=end

print "Enter the year: "
# STDOUT - global constant - the actual standard output stream for the program
# flush - flushes any buffered data within IO to the underlying operating system
STDOUT.flush

year = gets.chomp.to_i

isLeap = case
         when year % 400 == 0 then true
         when year % 100 == 0 then false
         else year % 4 == 0
         end
         
puts format("%4d %s a leap year",year,(isLeap ? "is" : "is not"))

