=begin
 UI test driver from nSight wizard test. 
=end

require 'windows_gui'
require 'wizard'

class TestWizard < Wizard
	include WindowsGui

	WIZARD_WINDOW_CLASS = 'WindowsForms10.Window.8.app.0.378734a'
	WIZARD_LBL_TITLE    = 'WindowsForms10.STATIC.app.0.378734a3'
	
	# The application name.
	@@app = TestWizard

	attr_reader :path, :main_window
	
	# Default options hash.
	DefaultOptions = {}
	
	BasePath = "D:\\Projects\\Raptor\\Plus\\v5.0\\Source\\Applications\\Managed\\nSpireWizardTest\\bin\\Debug"
	# TODO Remove?
#	WindowsGui.load_symbols "#{BasePath}\\\\src\\\\atlres.h"
	
	# Start the WizardTest application and get a window handle to it.
	def initialize(name = 'nSpireWizardTest', with_options = {})
		options = DefaultOptions.merge(with_options)
		
		@prompted = {}
		@path = TestWizard.path_to(name)
		
		system 'start "" "' + @path + '"'

		@main_window = Window.top_level '', 'WindowsForms10.Window.8.app.0.378734a', 5


		set_foreground_window @main_window.handle
	end

	# Set the path to a saved TestWizard file based on the base 
	# path for the WizardTest executable.
	def self.path_to(name)
		"#{BasePath}\\\\#{name}.exe"
	end

	# # Invoke a menu item.
	# def menu(name, item, wait = false)
		# multiple_words = /[.]/
		# single_word = /[ .]/
# 
		# # Split the passed in item using two different split patterns.
		# [multiple_words, single_word].each do |pattern|
		  # words = item.gsub(pattern, '').split
		  # const_name = ['ID', name, *words].join('_').upcase
		  # msg = WM_COMMAND
		  # 
		  # begin
			# id = WizardTest.const_get const_name
			# action = wait ? :send_message : :post_message
			# 
			# return send(action, @main_window.handle, msg, id, 0)
		  # rescue NameError
		  # end
		# end
	# end
# 
	# # Enter a password into a password dialog.
	# def enter_password(with_options = {})
		# options = DefaultOptions.merge with_options
		# 
		# @prompted[:for_password] = dialog(@@titles[:dialog]) do |d|
			# type_in options[:password]
			# confirmation = options[:confirmation] == true ? 
				# options[:password] : options[:confirmation]
			# if confirmation
				# keystroke VK_TAB
				# type_in confirmation
			# end
			# d.click options[:cancel_password] ? IDCANCEL : IDOK
		# end
	# end
# 
# 
	# WholeWord = 0x0410
	# ExactCase = 0x0411
	# SearchUp  = 0x0420
# 
	# # Find a term in the text area.
	# def find(term, with_options={})
		# menu 'Edit', 'Find...'
# 
		# appeared = dialog('Find') do |d|
			# type_in term
# 
			# d.click WholeWord if with_options[:whole_word]
			# d.click ExactCase if with_options[:exact_case]
			# d.click SearchUp  if :back == with_options[:direction]
# 
			# d.click IDOK
			# d.click IDCANCEL
		# end
# 
		# raise 'Find dialog did not appear' unless appeared
		# 
	# end
# 
	# # Return the current selection.
	# def selection
		# result = send_message @edit_window.handle, EM_GETSEL, 0, 0
		# bounds = [result].pack('L').unpack('SS')
		# bounds[0]...bounds[1]
	# end
# 
	# def go_to(where)
		# case where
		# when :beginning
			# keystroke VK_CONTROL, VK_HOME
		# when :end
			# keystroke VK_CONTROL, VK_END
		# end
	# end
	# 
	# ErrorIcon = 0x0014
# 
	# # Look for error message boxes.
	# def watch_for_error
		# if @prompted[:for_password]
			# @prompted[:with_error] = dialog(@@titles[:dialog]) do |d|
				# if (get_dlg_item(d.handle, ErrorIcon) > 0)
					# d.click IDCANCEL 
				# end
			# end
		# end
	# end
# 
	# # Select all text in the text area.
	# def select_all
		# keystroke VK_CONTROL, ?A
	# end
	# 
	# # The text from WizardTest's editor window.
	# def text
		# @edit_window.text
	# end
# 
	# # Comparison operator.
	# def text=(message)
		# keystroke VK_CONTROL, ?A
		# keystroke VK_BACK
		# type_in(message)
	# end

	# Is the TestWizard application running?
	def running?
		puts "running? #{@main_window} , #{is_window(@main_window.handle)}" 
		@main_window != 0 && is_window(@main_window.handle) != 0
	end
	
end
