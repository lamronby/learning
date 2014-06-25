=begin
 RSpec stuff for windows_gui
=end

require 'win32_gui'

describe WindowsGui do
	include WindowsGui

	it 'wraps a Windows call with a method' do
		find_window(nil, nil).should_not == ()
	end

	it 'enforces the argument count' do
		lambda {find_window}.should raise_error
	end
end

describe String, '#snake_case' do
	it 'transforms CamelCase strings' do
		'GetCharWidth32'.snake_case.should == 'get_char_width_32'
	end

	it 'leaves snake_case string intact' do
		'keybd_event'.snake_case.should == 'keybd_event'
	end
end

