=begin
 Exercise1. Write a method called month_days, that determines the number of 
 days in a month. Usage:

  days = month_days(5) # 31 (May)
  days = month_days(2, 2000) # 29 (February 2000)

 Remember, you would require the Date class here. Read up the online
 documentation of the same.
=end

# require 'Date'

def month_days(month, *args)
    if (!((1..12) === month))
        fail "Invalid month"
    end

    if (args[0] != nil)
        year = args[0]
    else
        t = Time.now
        year = t.strftime("%Y").to_i
    end

    d = Date.new(year, month, -1)
    
    # This creates a time object for the last day of the month
    # puts "Year #{year}, month #{month}, -1"
    # t = Time.utc(year, month)
    # month_days = t.strftime("%d")
    
    # is_leap = case
             # when year % 400 == 0 then true
             # when year % 100 == 0 then false
             # else year % 4 == 0
             # end

    # month_days = (is_leap) ? Time::LeapYearMonthDays[month] : Time::CommonYearMonthDays[month]
    
    puts "In year #{year}, month #{month} has #{d.day} days"
end


if __FILE__ == $0
    print "Enter the numeric month (1-12): "
    STDOUT.flush
    month = gets.chomp.to_i

    print "Enter the 4-digit year (skip to use current year: "
    STDOUT.flush
    year = gets.chomp.to_i
    year = 2008 if year <= 0
 
    month_days(month, year)
end
