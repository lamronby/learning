=begin
 Ratings class.
=end

class Ratings
    def initialize(min = 1, max = 5)
        @minimum = min
        @maximum = max
    end
    
    def to_s
        format("min: %2d, max: %2d\n", @minimum, @maximum)
    end
    
    attr_reader :minimum, :maximum
end


