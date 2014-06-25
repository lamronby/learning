=begin
 Solution class
=end

require 'log4r'
require 'factor'

include Log4r

class Solution
    def initialize(name, factor)
        @factors = Array.new
        @pros = Array.new
        @cons = Array.new
        @name = name
        self.add_factor(factor)
        # create a logger
        @log = Logger.new("decisionator::solution")
    end

    # Add an array of factors or a single factor to the factors for this
    # solution.
    def add_factor(factor)
        # If factor is an array, add it as an array. Otherwise, push the new
        # factor on the array.
        if (factor.kind_of? Array)
		  # TODO fix
          @factors = @factors + factor
          factor.each { |one_factor| add_pros_cons(one_factor) }
        elsif (factor.kind_of? Factor)
          @factors.push(factor)
          add_pros_cons(factor)
        end
    end
    
    def score()
        pro_total = 0
        con_total = 0
        @pros.each do |factor|
            pro_total += factor.rating
        end
        @cons.each do |factor|
            con_total += factor.rating
        end
        @log.debug "pro total: #{pro_total}, con total: #{con_total}" if @log.debug?
        (pro_total/@pros.length) - (con_total/@cons.length)
    end
    
    def to_s
        "Solution: " + @name + "\n" + @factors.to_s
    end

    attr_reader :name, :factors, :pros, :cons

    private
    
    # Keep separate arrays for pros and cons.
    def add_pros_cons(factor)
        if (factor.pro_or_con == Factor::PRO)
          @pros.push(factor)
        else
          @cons.push(factor)
        end
    end

end


