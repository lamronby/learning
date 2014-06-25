=begin
 Exercise1. Write a class called Person, that has balance as an instance variable and the following public method: show_balance.
 I shall create the Person object as follows:
 
 p = Person.new(40000)
 puts p.show_bal # calling the method
 
 In the above code, 40000 is an amount figure that needs to be added to balance.
=end

class Person
    def initialize(balance)
        @balance = balance
    end
    
    def show_balance
        @balance
    end
end


p = Person.new(40000)
puts p.show_balance

