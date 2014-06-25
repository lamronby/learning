=begin
 Dog class
=end

class Dog
    @name
    
    def initialize(name)
        @name = name
    end
    
    def bark
        puts "#{@name} says woof woof"
    end
    
    def eat
        puts "#{@name} is eating: Chomp, chew slobber."
    end
    
    def chase_cat
        puts "#{@name} is running to chase the cat..."
    end
end

d = Dog.new(ARGV[0])
d.bark
d.eat
d.chase_cat

