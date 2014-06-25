=begin
 Decision class. A decision has the following relationships:
   - (1..1) a minimum rating property
   - (1..1) a maximum rating property
   - (1..1) a graphic property
   - (1..1) a problem statement
   - (1..2) solutions
     - (0..n) solution factors
       - (1..1) factor type
       - (1..1) factor rating
=end

require 'ratings'
require 'problem'
require 'solution'
require 'factor'
require 'rexml/document'
require 'log4r'

include Log4r

class Decision
    
    # Define element keys
    PROBLEM_ELEM = "problem"
    SOLUTION_ELEM = "solution"
    FACTOR_ELEM = "factor"
    
    # Define attribute keys
    NAME_ATTR = "name"
    MIN_RATING_ATTR = "min_rating"
    MAX_RATING_ATTR = "max_rating"
    GRAPHIC_ATTR = "graphic"
    FACTOR_TYPE_ATTR = "type"
    FACTOR_RATING_ATTR = "rating"
    
    # TODO: change access control to enforce factory use?
    def initialize(min, max, *other_args)
        @ratings = Ratings.new(min, max)
        
        # Problem statement
        if (other_args[0])
            @problem = other_args[0] if (other_args[0].kind_of? Problem)
        end
        
        # Solution(s).
        if (other_args[1])
            # If this is an array, set the instance variable to the array.
            # Otherwise, create a new array.
            @solutions = (other_args[1].is_a? Array) ? other_args[1] :
                [other_args[1]]
        end
        
        # create a logger
        @log = Logger.new("decisionator::decision")
    end
    
    
    def problem=(problem)
        @problem = problem if (problem.kind_of? Problem)
    end

    def add_solution(solution)
        @solutions.push(solution) if (solution.kind_of? Solution)
    end

    def to_s
        output = format("Problem: %s\nRating settings: %s\n", @problem,
            @ratings.to_s)
        output << @solutions.to_s
        output
    end
    
    # Create a new decision. This method acts as a factory method.
    def self.create_decision(min, max, problem)
        decision = Decision.new(min, max, Problem.new(problem))
        decision
    end
    
    # TODO Consider making a mixin, once I understand them better.
    # Read decision information from XML.
    def self.read_decision(file)
        # create a logger
        log = Logger.new("decisionator::decision")
        
        doc = REXML::Document.new(file)

        root = doc.root
        
        # Get the root-level attributes
        min_rating = root.attributes[MIN_RATING_ATTR]
        max_rating = root.attributes[MAX_RATING_ATTR]
        graphic = root.attributes[GRAPHIC_ATTR]
        
        # Get the problem statement
        problem_stmt = root.elements[PROBLEM_ELEM].text
        
        # TODO Throw exception if no problem element

        solutions = []
        # Parse solutions
        root.elements.each(SOLUTION_ELEM) do |solution_element|
            factors = []
            # Parse factors within each solution.
            solution_element.elements.each(FACTOR_ELEM) do |factor_elem|
                factors.push(Factor.new(factor_elem.attributes[FACTOR_TYPE_ATTR],
                    factor_elem.attributes[FACTOR_RATING_ATTR].to_i,
                    factor_elem.text))
            end
            solutions.push(Solution.new(solution_element.attributes[NAME_ATTR],
                factors))
        end

        log.debug("Min: #{min_rating}, max: #{max_rating}")
        decision = Decision.new(min_rating, max_rating,
            Problem.new(problem_stmt), solutions)
        decision
    end

    attr_reader :problem, :solutions, :ratings
end

