=begin
 Test cases for Solution class.
=end

require 'solution'
require 'factor'
require 'test/unit'
require 'log4r'

include Log4r

class TestSolution < Test::Unit::TestCase

  def setup
    # Get the root logger and set its level to DEBUG. This makes the global
    # level WARN.
    Logger.root.level = Log4r::DEBUG

    # Specify logging output format
    format = PatternFormatter.new(:pattern => "%d [%l] (%c) - %m")
    StdoutOutputter.new('console', :formatter => format)
    
    @log = Logger.new('decisionator')
    @log.add('console')
    
  end
  
  # Tests the scoring logic of the Solution class
  def test_solution_score
    @log.debug("This is a test message.")
	factor = [ Factor.new("con", 3, "more fat"), 
			   Factor.new("pro", 2, "more protein") ]
    solution = Solution.new("bacon and eggs", factor)
    
    # Test solution name
    assert_equal("bacon and eggs", solution.name, "Soluation name is incorrect.")
    
    # Test solution pros
    pros = solution.pros
    assert_equal("pro", pros[0].pro_or_con, "Pro factor type is incorrect.")
    assert_equal(2, pros[0].rating, "Pro factor rating is incorrect.")
    assert_equal("more protein", pros[0].description, 
      "Pro factor description is incorrect.")
    
    # Test solution cons
    cons = solution.cons
    assert_equal("con", cons[0].pro_or_con, "Con factor type is incorrect.")
    assert_equal(3, cons[0].rating, "Con factor rating is incorrect.")
    assert_equal("more fat", cons[0].description, 
      "Con factor description is incorrect.")

    # Test solution score.
    assert_equal(solution.score, -1, "Solution score is incorrect.")
  end
end
