#---
# Excerpted from "Programming Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/ruby3 for more book information.
#---
require 'test/unit'
def ARGF.read
 nil
end
class TestsWhichFail < Test::Unit::TestCase
  def test_reading
    assert_not_nil(ARGF.read, "Read next line of input")
  end
end
