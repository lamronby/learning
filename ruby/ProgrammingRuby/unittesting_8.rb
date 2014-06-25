#---
# Excerpted from "Programming Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/ruby3 for more book information.
#---
require 'roman'
require 'test/unit'
class TestRoman < Test::Unit::TestCase

  def test_range
    assert_raise(RuntimeError) { Roman.new(0) }
    assert_nothing_raised()    { Roman.new(1) }
    assert_nothing_raised()    { Roman.new(4999) }
    assert_raise(RuntimeError) { Roman.new(5000) }
  end
end
