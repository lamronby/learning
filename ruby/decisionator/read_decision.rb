
require "rexml/document"

def read_decision(file)
    
    # Define element keys
    PROBLEM_ELEM = "problem"
    SOLUTION_ELEM = "solution"
    FACTOR_ELEM = "factor"
    
    # Define attribute keys
    MIN_RATING_ATTR = "min_rating"
    MAX_RATING_ATTR = "max_rating"
    GRAPHIC_ATTR = "graphic"
    FACTOR_TYPE_ATTR = "type"
    FACTOR_RATING_ATTR = "rating"
    
    if (!File.exist?(file))
        # TODO throw exception
        puts "File #{file} does not exist."
    end

    file = File.new(file)
    doc = REXML::Document.new(file)

 
# <decision min_rating="1" max_rating="5" graphic="star"/>
    # <problem>Should I have bacon and eggs or cereal for breakfast?</problem>
    # <solution name="bacon and eggs">
        # <factor type="con" rating="3">more fat</factor>
        # <factor type="pro" rating="2">more protein</factor>
    # </solution>
    # <solution name="cereal">
        # <factor type="con" rating="5">less filling</factor>
        # <factor type="pro" rating="1">lower fat</factor>
        # <factor type="pro" rating="3">more options</factor>
    # </solution>
# </decision>

    root = doc.root
    min_rating = root.attributes[MIN_RATING_ATTR]
    max_rating = root.attributes[MAX_RATING_ATTR]
    graphic = root.attributes[GRAPHIC_ATTR]
    
    problem_stmt = doc.elements[PROBLEM_ELEM]
    
    # TODO Throw execption if no problem element
    
    # Parse solutions
    doc.elements.each(SOLUTION_ELEM) |solution_element| do
        element.each(FACTOR_ELEM) |factor_elem| do
            factors += Factor.new(factor_elem.attributes[FACTOR_TYPE_ATTR],
                factor_elem.attributes[FACTOR_RATING_ATTR].to_i,
                factor_elem.text)
        end
        solutions += Solution.new(solution_element.text, factors)
    end

end
