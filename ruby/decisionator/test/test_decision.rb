=begin
 Test cases for Decision class.
=end

require 'decision'
require 'test/unit'

class TestDecision < Test::Unit::TestCase

  # Tests instantiation of a decision using XML.    
  def test_read_decision
      test_xml = <<END
<decision min_rating="1" max_rating="5" graphic="star">
    <problem>Should I have bacon and eggs or cereal for breakfast?</problem>
    <solution name="bacon and eggs">
        <factor type="con" rating="3">more fat</factor>
        <factor type="pro" rating="2">more protein</factor>
    </solution>
    <solution name="cereal">
        <factor type="con" rating="5">less filling</factor>
        <factor type="pro" rating="1">lower fat</factor>
        <factor type="pro" rating="3">more options</factor>
    </solution>
</decision>
END

    decision = Decision.read_decision(test_xml)
    puts decision.to_s

    # Test decision attributes
    assert_equal("1", decision.ratings.minimum, "Decision min is incorrect.")
    assert_equal("5", decision.ratings.maximum, "Decision min is incorrect.")

    # Test problem statement.
    assert_equal("Should I have bacon and eggs or cereal for breakfast?",
        decision.problem.statement, "Problem statement is incorrect.")

    # Test first solution.
    assert_equal("bacon and eggs", decision.solutions[0].name,  
        "Solution statement is incorrect.")
        
    # Test factors for first solution.
    assert_equal("con", decision.solutions[0].factors[0].pro_or_con, 
        "Factor 0 for #{decision.solutions[0].name} is incorrect.")
    assert_equal(3, decision.solutions[0].factors[0].rating, 
        "Factor 0 for #{decision.solutions[0].name} is incorrect.")
    assert_equal("more fat", decision.solutions[0].factors[0].description,  
        "Factor 0 for #{decision.solutions[0].name} is incorrect.")
        
    assert_equal("pro", decision.solutions[0].factors[1].pro_or_con,  
        "Factor 1 for #{decision.solutions[0].name} is incorrect.")
    assert_equal(2, decision.solutions[0].factors[1].rating,  
        "Factor 1 for #{decision.solutions[0].name} is incorrect.")
    assert_equal("more protein", decision.solutions[0].factors[1].description,  
        "Factor 1 for #{decision.solutions[0].name} is incorrect.")

    # Test second solution.
    assert_equal("cereal", decision.solutions[1].name,  
        "Solution statement is incorrect.")

    # Test factors for second solution.
    assert_equal("con", decision.solutions[1].factors[0].pro_or_con,  
        "Factor 0 for #{decision.solutions[1].name} is incorrect.")
    assert_equal(5, decision.solutions[1].factors[0].rating,  
        "Factor 0 for #{decision.solutions[1].name} is incorrect.")
    assert_equal("less filling", decision.solutions[1].factors[0].description,  
        "Factor 0 for #{decision.solutions[1].name} is incorrect.")
        
    assert_equal("pro", decision.solutions[1].factors[1].pro_or_con,  
        "Factor 1 for #{decision.solutions[1].name} is incorrect.")
    assert_equal(1, decision.solutions[1].factors[1].rating,  
        "Factor 1 for #{decision.solutions[1].name} is incorrect.")
    assert_equal("lower fat", decision.solutions[1].factors[1].description,  
        "Factor 1 for #{decision.solutions[1].name} is incorrect.")
        
    assert_equal("pro", decision.solutions[1].factors[2].pro_or_con,  
        "Factor 2 for #{decision.solutions[1].name} is incorrect.")
    assert_equal(3, decision.solutions[1].factors[2].rating,  
        "Factor 2 for #{decision.solutions[1].name} is incorrect.")
    assert_equal("more options", decision.solutions[1].factors[2].description,  
        "Factor 2 for #{decision.solutions[1].name} is incorrect.")
        
  end
end
