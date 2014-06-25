
describe 'The main window' do
	# Open a new wizard dialog at the beginning of each test.
	before :each do
		@wizard = Wizard.open
	end

	# Close the wizard dialog.
	after :each do
		@wizard.exit! if @wizard.running?
	end
	
	it 'starts successfully' do
		@wizard.should_not == nil
	end

	# it 'should contain a back button, next button, and cancel button' do
		# @wizard = 
	
end
