=begin
 Provide support for testing the LockNote application.
=end

require 'win32_gui'
require 'note'

class LockNote < Note
	include WindowsGui

	# The application name.
	@@app = LockNote

	# An array of window titles for the LockNote application.
	@@titles =
	{
		:file => 'Save As',
		:exit  => 'Steganos LockNote',
		:about => 'About Steganos LockNote...',
		:about_menu  => 'About',
		:dialog => 'Steganos LockNote'
	}

	BasePath = "D:\\Tools\\LockNote 1.0.3"
	WindowsGui.load_symbols "#{BasePath}\\src\\resource.h"
	WindowsGui.load_symbols "#{BasePath}\\src\\atlres.h"
	ID_HELP_ABOUT = ID_APP_ABOUT  
	ID_FILE_EXIT = ID_APP_EXIT
  
	# Start the LockNote application and get a window handle to it.
	def initialize(name = 'LockNote', with_options = {})
		options = DefaultOptions.merge(with_options)
		
		@prompted = {}
		@path = LockNote.path_to(name)
		
		system 'start "" "' + @path + '"'
		unlock_password options

		if @prompted[:with_error] || options[:cancel_password]
			@main_window = Window.new 0
			sleep 1.0
		else
			@main_window = Window.top_level "#{name} - Steganos LockNote"
			@edit_window = @main_window.child "ATL:00434310"

			set_foreground_window @main_window.handle
		
		end

	end

	# Set the path to a saved LockNote file based on the base 
	# path for the LockNote executable.
	def self.path_to(name)
		"#{BasePath}\\#{name}.exe"
	end
	
	# Invoke a menu item.
	def menu(name, item, wait = false)
		multiple_words = /[.]/
		single_word = /[ .]/

		# Split the passed in item using two different split patterns.
		[multiple_words, single_word].each do |pattern|
		  words = item.gsub(pattern, '').split
		  const_name = ['ID', name, *words].join('_').upcase
		  msg = WM_COMMAND
		  
		  begin
			id = LockNote.const_get const_name
			action = wait ? :send_message : :post_message
			
			return send(action, @main_window.handle, msg, id, 0)
		  rescue NameError
		  end
		end
	end

	# Enter a password into a password dialog.
	def enter_password(with_options = {})
		options = DefaultOptions.merge with_options

		@prompted[:for_password] = dialog(@@titles[:dialog]) do |d|
			puts "Entering password in dialog #{d}"
			type_in options[:password]
			confirmation = options[:confirmation] == true ? 
				options[:password] : options[:confirmation]
			if confirmation
				keystroke VK_TAB
				type_in confirmation
			end
			d.click options[:cancel_password] ? IDCANCEL : IDOK
		end
	end


	WholeWord = 0x0410
	ExactCase = 0x0411
	SearchUp  = 0x0420

	# Find a term in the text area.
	def find(term, with_options={})
		menu 'Edit', 'Find...'

		appeared = dialog('Find') do |d|
			type_in term

			d.click WholeWord if with_options[:whole_word]
			d.click ExactCase if with_options[:exact_case]
			d.click SearchUp  if :back == with_options[:direction]

			d.click IDOK
			d.click IDCANCEL
		end

		raise 'Find dialog did not appear' unless appeared
		
	end

	# Return the current selection.
	def selection
		result = send_message @edit_window.handle, EM_GETSEL, 0, 0
		bounds = [result].pack('L').unpack('SS')
		bounds[0]...bounds[1]
	end

	def go_to(where)
		case where
		when :beginning
			keystroke VK_CONTROL, VK_HOME
		when :end
			keystroke VK_CONTROL, VK_END
		end
	end
	
	ErrorIcon = 0x0014

	# Look for error message boxes.
	def watch_for_error
		if @prompted[:for_password]
			@prompted[:with_error] = dialog(@@titles[:dialog]) do |d|
				if (get_dlg_item(d.handle, ErrorIcon) > 0)
					d.click IDCANCEL 
				end
			end
		end
	end

	# Select all text in the text area.
	def select_all
		keystroke VK_CONTROL, ?A
	end
	
	# The text from LockNote's editor window.
	def text
		@edit_window.text
	end

	# Comparison operator.
	def text=(message)
		keystroke VK_CONTROL, ?A
		keystroke VK_BACK
		type_in(message)
	end

	# Is the LockNote application running?
	def running?
		@main_window != 0 && is_window(@main_window.handle) != 0
	end
	
end
