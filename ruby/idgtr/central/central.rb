=begin
	Base class for testing nSight Central.
end
=end

# add the path to win32_gui
$: << 'D:/Learning/ruby/idgtr/lib'

require 'win32_gui'
require 'fileutils'
require 'rexml/document'
require 'app_config'
require 'log4r'

class Central
	include WindowsGui

	# The application name.
	@@app = Central

	attr_reader :path, :main_window, :externalLinks
	
	# An array of window titles for the application.
	@@titles =
	{
		:search => 'Patient Search',
		:change_db  => 'Change Database',
	}

	# Default options hash.
	DefaultOptions = {
		:use_desktop_link => false,
		:link_name => 'nSight'
	}
	
	
	BasePath = "D:\\Projects\\Raptor\\Plus\\v5.0\\Output"
	LinkPath = "C:\\Users\\cjansen\\Desktop"

	attr_reader :path

	# Start nSight Central and get a window handle to it.
	def initialize(name = 'nSightCentral', with_options = {})
		options = DefaultOptions.merge(with_options)
		
		@prompted = {}

		if options[:use_desktop_link]
			raise "No link name specified" if (!options[:link_name])
			@path = Central.link_to(options[:link_name])
		else
			@path = Central.path_to(name)
		end

		# Load app config and external link data.
		load_app_config(name)
		load_external_links()
		
		system 'start "" "' + @path + '"'

		@main_window = Window.top_level 'nSight Central'

		# Create or get a logger.
		@log = (Log4r::Logger['Central']) ? 
			(Log4r::Logger['Central']) : Log4r::Logger.new('Central')
		
		# Look for the "connecting to database" dialog.
		begin
			@connecting_window = Window.top_level("Connecting ...")
			if (@connecting_window.handle > 0)
				@log.debug("Connecting to db window detected...")
				@connecting_window.wait_for_close(10)
				@log.debug("Connecting to db window is closed...")
			end
		rescue RuntimeError
			@log.debug("Database connection window not detected")
		end

		# Give a little time for the database-dependent controls to initialize.
		sleep 0.5
		
		set_foreground_window @main_window.handle
	end

	# Set the path to a saved TestWizard file based on the base 
	# path for the WizardTest executable.
	def self.path_to(name)
		"#{BasePath}\\\\#{name}.exe"
	end

	def self.link_to(name)
		"#{LinkPath}\\\\#{name}.lnk"
	end

	def self.path_to_config(name)
		"#{BasePath}\\\\#{name}.exe.config"
	end
	
	# Create a new instance of an application
	def self.open(*args)
		@@app.new *args
	end

	# Close the application.
	def exit!(with_options = {})
		options = DefaultOptions.merge with_options

		@log.debug("Closing Central by clicking on Exit button...")
		
		begin
			@main_window.click('E_xit')
		rescue Exception
			@log.info("Exception while closing Central: #{$!.message}")
			# There was an issue with clicking the exit button. If
			# the application is still running, raise the exception.
			# Otherwise, we don't care.
			raise if running?
			@log.info("Ignoring Central close exception, window is closed.")
		end

		@log.debug("Waiting for app to close...")
		@main_window.wait_for_close
		@log.debug("Closed.")
	end

	# Did the UI prompt?
	def has_prompted?(kind)
		@prompted[kind]
	end

	# Is the application running?
	def running?
		is_a_window = (@main_window == 0) ? 
			false : (is_window(@main_window.handle) != 0)
		
		@log.debug("Main window: #{@main_window.handle}, is a window: #{is_a_window}")
		is_a_window
	end

	# Click on a web link. If the click is successful, verify that a
	# window opens to the expected location, and then close the window.
	def click_web_link(text)
		@log.debug("Clicking web link #{text}")
		
		@main_window.click(text)
	end

	# Click on a shortcut button. If the click is successful, wait to see
	# if the application opens.
	def click_shortcut(text, seconds = 5)
		@main_window.click(text)

		@log.debug("Clicked \"#{text}\" shortcut, waiting #{seconds} seconds for Central window to close...")
		timeout(seconds) do
			sleep 0.2 while running?
		end
	end

	private

	def load_app_config(name)

		@appSettings = Hash.new
	
		if (!File.exist?(Central.path_to_config(name)))
			raise "File #{file} does not exist."
		end

		@appSettings = AppConfig.load(Central.path_to_config(name))
	end

	def load_external_links()
		@externalLinks = Hash.new

		return if (@appSettings == nil)
		
		linkElems = @appSettings["external_links"].split( '|' )

		while (linkElems.shift) do
			# skip Guid, get the link name
			linkName = linkElems.shift
			# skip description
			linkElems.shift
			# get target
			@externalLinks[linkName] = linkElems.shift
			# skip resource key
			linkElems.shift
		end
	end


end

if __FILE__ == $0
	central = Central.open
	sleep 5
	central.click_web_link("nSpire Health Online")
end



