=begin
 Exercise4. Write a method leap_year. Accept a year value from the user, check whether it's a leap year and then display the number of minutes in that year - program p017leapyearmtd.rb.
=end

def leap_year
    print "Enter the year: "
    STDOUT.flush
    year = gets.chomp.to_i

    isLeap = case
             when year % 400 == 0 then true
             when year % 100 == 0 then false
             else year % 4 == 0
             end
        
    yearMinutes = (60 * 24) * (isLeap ? 366 : 365)
    
    puts format("%d %s a leap year and has %d minutes",year,(isLeap ? "is" : "is not"), yearMinutes)
end

leap_year

