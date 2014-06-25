=begin
 Problem class
=end

class Problem
    
    def initialize(statement)
        @statement = statement
    end
    
    def to_s
        @statement
    end
    # imply solutions?
    attr_reader :statement
end


