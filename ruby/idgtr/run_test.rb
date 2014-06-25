
#require 'LockNote'
require 'log4r'
require 'win32_gui'
include WindowsGui
include Log4r

require 'win32/api'
include Win32

# Recurses the child controls of a window handle to find all children.
class ChildRecurser
	
	# Define the EnumChildWindows API call.
	@@EnumChildWindows = API.new('EnumChildWindows', 'LKP', 'L', 'user32')
	# Define the GetWindowText API call.
	@@GetWindowText   = API.new('GetWindowText', 'LPI', 'I', 'user32')
	# Define the GetClassName API call.
	@@GetWindowClass = API.new('GetClassName', 'LPL', 'L', 'user32')
	
	def initialize
		@allChildren = Hash.new
		@childProcCalled = Hash.new
		@childrenToCall = Array.new
		
		@findTextOnly = false

        # create a logger
        @log = Logger.new("run_test::ChildRecurser")
		
		# procedure for processing child controls.
		@ChildWindowsProc = API::Callback.new('LL', 'I'){ |winHandle, parent|
			if (@allChildren[winHandle] == nil)
				printControlInfo( parent, winHandle )
				@allChildren[winHandle] = 1
				@childrenToCall.push( winHandle )
			end
			
			true
	   }
	end

	# Recurse through children of the window_handle.
	def recurse_children( window_handle, findTextOnly = false )

		@findTextOnly = findTextOnly
		
		# Process the parent window.
		if (@allChildren[window_handle] == nil)
			printControlInfo( 0, window_handle )
			@allChildren[window_handle] = 1
		end

		# Enumerate the control's children.
		if (@childProcCalled[window_handle] == nil)
			# Enumeration has not been called on this control, so call it.
			@log.debug( "Calling EnumChildWindows on handle #{window_handle}")
			@@EnumChildWindows.call(window_handle, @ChildWindowsProc, window_handle)
			@childProcCalled[window_handle] = 1
			
			# While the array of children to call is not empty, recurse
			# children.
			while (@childrenToCall.first != nil)
				handle = @childrenToCall.shift
				@log.debug( "Calling recurse_children, parent #{window_handle}, child #{handle}")
				recurse_children( handle )
			end
		else
			@log.debug( "EnumChildWindows has already been called for handle #{window_handle}")
		end
	end

private

	def printControlInfo( parent, winHandle)
		# The control has not been processed yet, so process it.
		
		text = "\0" * 200
		clss = "\0" * 200
		@@GetWindowText.call(winHandle, text, 200);
		@@GetWindowClass.call(winHandle, clss, 200);

		if (@findTextOnly)
			puts "#{parent}\t#{winHandle}\t#{text.strip}\t#{clss.strip}" if (text.strip.length > 0)
		else
			puts "#{parent}\t#{winHandle}\t#{text.strip}\t#{clss.strip}"
		end
	end
	
end

if __FILE__ == $0

    # Get the root logger and set its level.
    Logger.root.level = Log4r::DEBUG

    # Specify logging output format.
    format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    
    log = Logger.new('run_test')

	# Create an outputter for $stdout.
	StdoutOutputter.new('console', :formatter=>format, :level=>Log4r::INFO)
	# StdoutOutputter.new('console', :formatter => format)
	log.add('console')

	#-- nSpireWizardTest -------------------------------
	# system 'start ""  "D:\\Projects\\Raptor\\Plus\\v5.0\\Source\\Applications\\Managed\\nSpireWizardTest\\bin\\Debug\\nSpireWizardTest.exe"'
	# main_window = Window.top_level '', 'WindowsForms10.Window.8.app.0.378734a', 5

	#-- nSightDbUtilities -------------------------------
	# system 'start ""  "D:\\Projects\\Raptor\\Plus\\v5.0\\Source\\Applications\\Managed\\nSightDbUtilities\\bin\\Debug\\nSightDbUtilities.exe"'
	# main_window = Window.top_level('Create New Database')
	
	#-- PlusStudy -------------------------------
	# system 'start ""  "D:\\Projects\\Raptor\\Plus\\v5.0\\Output\\PlusStudy.exe"'
	# main_window = Window.top_level("nSight - [Patient Information]")
	
	#-- nSight Central -------------------------------
	system 'start "" "D:\\Projects\\Raptor\\Plus\\v5.0\\Output\\nSightCentral.exe"'
	main_window = Window.top_level("nSight Central")

	#-- winMd5Sum -------------------------------
	# system 'start "" "C:\\Personal\\winMd5Sum\\winMd5Sum.exe"'
	# main_window = Window.top_level("winMd5Sum - Nullriver Software")

	#-- LockNote -------------------------------
	# system 'start "" "D:\\Tools\\LockNote 1.0.3\\LockNote.exe"'
	# main_window = Window.top_level("LockNote - Steganos LockNote")

	puts "main_window handle is #{main_window.handle}, class_name=#{main_window.class_name}"

	log.debug("Sleeping...")
	sleep( 5 )
	log.debug("Done sleeping")
	recurser = ChildRecurser.new
	recurser.recurse_children( main_window.handle )
	
	# FindWindowEx = Win32::API.new('FindWindowEx', 'LLPP', 'L', 'user32')
	# child_window = FindWindowEx.call(main_window.handle, 0, nil, "Compare")
# 
	# button = Window.new(child_window)
	# puts "child_window: #{child_window}, class_name=#{button.class_name}"
	# 
	# child_window = FindWindowEx.call(main_window.handle, 0, "Button", nil)
	# puts "child_window: #{child_window}"

	# EnumChildWindows.call(main_window.handle, EnumChildWindowsProc, 
	# 	main_window.handle)

	# children.each do |handle|
		# EnumChildWindows.call(handle, EnumChildWindowsProc, handle)
	# end

	# child_window = main_window.child "Erik"
	# puts "child_window is #{child_window}"
# 
	# FindWindowEx = Win32::API.new('FindWindowEx', 'LLPP', 'L', 'user32')
	
	# child_window = FindWindowEx.call(main_window.handle, 0, nil, "Pytte")
	# puts "child_window is #{child_window}"
	
	# child_window = FindWindowEx.call(main_window.handle, 0, 'WindowsForms10.Window.8.app.0.378734a', nil)
	# puts "child_window is #{child_window}"
	# 
	# child_window = FindWindowEx.call(main_window.handle, 0, nil, "&Cancel")
	# puts "child_window is #{child_window}"
 
	# child_window = FindWindowEx.call(main_window.handle, 0, 'WindowsForms10.BUTTON.app.0.378734a2', nil)
	# puts "child_window is #{child_window}"
 
	# child_window = FindWindowEx.call(main_window.handle, 0, nil, "Blank space")
	# puts "child_window is #{child_window}"
	
	# FindWindowEx = Win32::API.new('FindWindowEx', 'LLPP', 'L', 'user32')
	# foo = "ATL:00434310"
	# edit_window = FindWindowEx.call(main_window.handle, 0, foo, nil)

#	edit_window = main_window.child "ATL:00434310"

#	puts "edit_window: #{edit_window}"
	
	
#	@note = Note.open
#	@note.text.should include('Welcome')
#	@note.exit! if @note.running?
	
#	@wizard.find_control(@wizard.main_window.handle, "&Cancel")
#	@wizard.exit! if @wizard.running?
end

