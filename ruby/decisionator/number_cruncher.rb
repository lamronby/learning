=begin
 NumberCruncher class. Crunches the ratings for solution factors.

 For each solution:
     - total ratings for pros and cons, then calc average
     - treat cons as negative, pros as positive
	 - add averaged pros and cons. If < 0, then cons win. If > 0, pros win.
	 - Solution with largest score wins.
=end

class NumberCruncher
    def self.crunch(decision)
        decision.solutions.each do |solution|
            solution.pros.each do |factor|
                pro_total += factor.rating
            end
            solution.cons.each do |factor|
                con_total += factor.rating
            end
        end
    end
end
