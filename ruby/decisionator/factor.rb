=begin
 Factor class.
=end

require 'factor_type'

class Factor
	PRO = "pro"
    CON = "con"
    
    def initialize(type, rating, description)
        # TODO Check against "enum"
        @pro_or_con = type
        # TODO Check min/max
        @rating = rating
        @description = description
    end

    def to_s
        @pro_or_con + ", " + @rating.to_s + ": " + @description + "\n"
    end
    
    attr_reader :pro_or_con, :rating, :description
end


