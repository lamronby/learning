
# add the path to win32_gui
$: << 'D:/Learning/ruby/idgtr'

require 'win32_gui'
require 'log4r'
require 'log4r/configurator'
require 'central'
require 'win32/api'

include WindowsGui
include Win32

if __FILE__ == $0

	# set any runtime XML variables
	Log4r::Configurator['logpath'] = './'
	# Load up the config file
	Log4r::Configurator.load_xml_file('./log4r_config.xml')

    # Get the root logger and set its level.
    # Log4r::Logger.root.level = Log4r::DEBUG

    log = Log4r::Logger.new("run_test", Log4r::DEBUG )
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
	# system 'start "" "D:\\Projects\\Raptor\\Plus\\v5.0\\Output\\nSightCentral.exe"'
	# main_window = Window.top_level("nSight Central")

	#-- winMd5Sum -------------------------------
	# system 'start "" "C:\\Personal\\winMd5Sum\\winMd5Sum.exe"'
	# main_window = Window.top_level("winMd5Sum - Nullriver Software")

	#-- LockNote -------------------------------
	# system 'start "" "D:\\Tools\\LockNote 1.0.3\\LockNote.exe"'
	# main_window = Window.top_level("LockNote - Steganos LockNote")

	# puts "main_window handle is #{main_window.handle}, class_name=#{main_window.class_name}"
# 
	# log.debug("Sleeping...")
	# sleep( 5 )
	# log.debug("Done sleeping")
	# recurser = ChildRecurser.new
	# recurser.print_all_children( main_window.handle )

	
	# child = main_window.child('nSpire University')
	# raise "Web link '#{text}' not found" if (child == nil)
	# child.click
	# sleep(2)
	# main_window.click('E_xit')

	central = Central.open
	sleep(5)

	# recurser = ChildRecurser.new
	# recurser.print_all_children(central.main_window.handle)

	begin
		central.click_shortcut("Patient Information")
	rescue
		log.debug( "Must not have found shortcut" )
	end

	central.running?
	central.exit!
	
	# central.click_web_link("nSpire University")
	# central.exit! if central.running?
	
	# child_window = main_window.child( "e&xit" ) 
	# if (child_window.handle > 0)
		# puts "child_window: #{child_window}, class_name=#{child_window.class_name}"
	# else
		# puts "Exit control not found."
	# end
 
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
 
end

