
require 'gameboard'

describe Gameboard do
	before :each do
		@gameboard = Gameboard.new
	end

	it 'should initially set locations as a 7 element array \n
	containing 0s and no_of_hits to 0' do
		@gameboard.locations.should == [0,0,0,0,0,0,0]
		@gameboard.no_of_hits.should == 0
	end

	it 'shouild be able to set_locations_cells' do
		@gameboard.should respond_to(:set_locations_cells)
	end

	it 'set_locations_cells should accept an argument (of an array)' do
		lambda {@gameboard.set_locations_cells}.should raise_error()
		lambda {@gameboard.set_locations_cells([2])}.should_not raise_error()
	end

	it 'set_locations_cells should receive an array of 3 elements and modify locations to mark valid targets of 1 in each of the indicated positions' do
		@gameboard.locations.should == [0,0,0,0,0,0,0]
		@gameboard.set_locations_cells([1,2,3])
		@gameboard.locations.should == [0,1,1,1,0,0,0]
	end

	it 'should have check_yourself(target_location)' do
		@gameboard.should respond_to(:check_yourself)
	end

	it 'check_yourself should change the locations target_location to 0' do
		@gameboard.set_locations_cells([1]).should == [0,1,0,0,0,0,0]
		@gameboard.check_yourself(1)
		@gameboard.locations.should == [0,0,0,0,0,0,0]
	end

	it 'should report miss' do
		@gameboard.set_locations_cells([1]).should == [0,1,0,0,0,0,0]
		@gameboard.check_yourself(0).should == :miss
	end
	
	it 'should report hit' do
		@gameboard.set_locations_cells([0,1]).should == [1,1,0,0,0,0,0]
		@gameboard.check_yourself(1).should == :hit
	end

	it 'check_yourself should report kill if it is the last target hit' do
		@gameboard.set_locations_cells([1]).should == [0,1,0,0,0,0,0]
		@gameboard.check_yourself(1).should == 'kill'
	end

end

 
