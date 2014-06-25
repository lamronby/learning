=begin
	RSpec common setup and teardown code.
=end

require 'log4r'
require 'log4r/configurator'

describe 'a clicked shortcut', :shared => true do
	# Open a new Central dialog.
	before do
		@central = Central.open
	end

	# Close the opened application.
	after do
		if (@shortcut_win)
			# Wait briefly since the app has a database connection and may
			# not have finished initializing.
			sleep 0.8
			@shortcut_win.close
			@shortcut_win.wait_for_close
		end
		@shortcut_win = nil
	end
end

describe 'a debug spec session', :shared => true do
	before do
		# set any runtime XML variables
		Log4r::Configurator['logpath'] = './'
		# Load up the config file
		Log4r::Configurator.load_xml_file('./log4r_config.xml')
	end
end

