=begin
 Windows GUI modules. Provides method wrappers for Win32 API calls.
=end
 
require 'log4r'

# Define extension methods for the String class.
class String
	# Converting CamelCase method names to "snake case" Ruby method names
	def snake_case
		gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
	end

	def to_keys
		unless size == 1
			raise "Conversion is for single characters only"
		end

		ascii = unpack('C')[0]

		case self
		when '0'..'9'
			[ascii - ?0 + 0x30]
		when 'A'..'Z'
			[WindowsGui.const_get(:VK_SHIFT), ascii]
		when 'a'..'z'
			[ascii - ?a + ?A]
		when ' '
			[ascii]
		when ','
			[WindowsGui.const_get(:VK_OEM_COMMA)]
		when '.'
			[WindowsGui.const_get(:VK_OEM_PERIOD)]
		when ':'
			[:VK_SHIFT, :VK_OEM_1].map {|s| WindowsGui.const_get s}
		when "\\"
			[WindowsGui.const_get(:VK_OEM_102)]
		else
			raise "Cannot convert unknown character #{self}"
		end
	end
end


require 'timeout'
require 'win32/api'

module WindowsGui

	# Add API methods directly to the WindowGui module.
	def self.def_api(function, parameters, return_value='L', rename = nil)
		api = Win32::API.new(function, parameters, return_value, 'user32') 

		define_method(rename || function.snake_case) do |*args|
		  api.call *args
		end
	end

	# Load symbols from a C header file.
	def self.load_symbols(header)
		File.open(header) do |f|
			f.grep(/#define\s+(ID\w+)\s+(\w+)/) do
				name = $1
				value = (0 == $2.to_i) ? $2.hex : $2.to_i
				WindowsGui.const_set name, value
			end
		end
	end
	
	# HWND FindWindow(LPCTSTR windowClass, LPCTSTR title);
	def_api 'FindWindow', 'PP'
	
	def_api 'FindWindowEx', 'LLPP'
	
	def_api 'SendMessage', 'LLLP', 'L', :send_with_buffer
	def_api 'SendMessage', 'LLLL'

	# BOOL PostMessage( HWND window, UINT message, WPARAM wParam, 
	#                   LPARAM lParam);
	def_api 'PostMessage', 'LLLL', 'I'
	
	# void keybd_event( BYTE keyCode, BYTE unused, DWORD event, 
	#                   DWORD extraInfo);
	def_api 'keybd_event', 'IILL', 'V'
		
	# HWND GetDlgItem(HWND dialog, int control);
	def_api 'GetDlgItem', 'LL'
	
	# BOOL GetWindowRect(HWND window, LPRECT rectangle)
	def_api 'GetWindowRect', 'LP', 'I'

	# int GetWindowText(HWND hWnd, LPTSTR lpString, int nMaxCount)
	def_api 'GetWindowText', 'LPL'

	# int GetClassName(HWND hWnd, LPTSTR lpClassName, int nMaxCount)
	def_api 'GetClassName', 'LPL' 

	def_api 'SetCursorPos', 'LL', 'I' 
	def_api 'mouse_event', 'LLLLL', 'V' 

	def_api 'IsWindow', 'L'
	def_api 'IsWindowVisible', 'L'

	def_api 'SetForegroundWindow', 'L'

	# Windows messages - general
	WM_COMMAND    = 0x0111
	WM_SYSCOMMAND = 0x0112
	SC_CLOSE      = 0xF060

	# Windows messages - text
	WM_GETTEXT = 0x000D
	EM_GETSEL  = 0x00B0
	EM_SETSEL  = 0x00B1

	# Commonly-used control IDs
	IDOK = 1
	IDCANCEL = 2
	IDYES = 6
	IDNO = 7
	
	# Mouse and keyboard flags
	MOUSEEVENTF_LEFTDOWN = 0x0002
	MOUSEEVENTF_LEFTUP = 0x0004
	KEYEVENTF_KEYDOWN = 0
	KEYEVENTF_KEYUP = 2
	
	# Modifier keys
	VK_SHIFT = 0x10
	VK_CONTROL = 0x11
	VK_MENU = 0x12 # Alt
	
	# Commonly-used keys
	VK_BACK = 0x08
	VK_TAB = 0x09
	VK_RETURN = 0x0D
	VK_ESCAPE = 0x1B
	VK_OEM_1 = 0xBA # semicolon (US)
	VK_OEM_102 = 0xE2 # backslash (US)
	VK_OEM_PERIOD = 0xBE
	VK_HOME = 0x24
	VK_END = 0x23
	VK_OEM_COMMA = 0xBC
	
	def keystroke(*keys)
		#valchk
		return if keys.empty?

		keybd_event keys.first, 0, KEYEVENTF_KEYDOWN, 0
		sleep 0.05
		keystroke *keys[1..-1]
		sleep 0.05 
		keybd_event keys.first, 0, KEYEVENTF_KEYUP, 0
	end

	def type_in(message)
		if (message.empty?)
			puts "Message is empty!"
			return
		end
		
		# The m regex option specifies "multi-line" mode
		message.scan(/./m) do |char|
			keystroke(*char.to_keys)
		end
	end

	def wait_for_window(title, seconds = 5)
		timeout(seconds) do
			sleep 0.2 while
				(h = find_window nil, title) <= 0 ||
				window_text(h) != title
			h
		end
	end
  
	class Window
		include WindowsGui
		extend WindowsGui

		attr_reader :handle, :children

		def initialize(handle)
			@handle = handle
			@log = (Log4r::Logger['WindowsGui::Window']) ? 
				(Log4r::Logger['WindowsGui::Window']) : Log4r::Logger.new('WindowsGui::Window')
		end

		def close
			post_message @handle, WM_SYSCOMMAND, SC_CLOSE, 0
		end

		def wait_for_close(seconds = 5)
			timeout(seconds) do
				sleep 0.2 until 0 == is_window_visible(@handle)
			end
		end

		def text(max_length = 2048)
			buffer = '\0' * max_length
			# length = get_window_text(@handle, buffer, max_length)
			length = send_with_buffer @handle, WM_GETTEXT, buffer.length, buffer
			length == 0 ? '' : buffer[0..length -1]
		end

		def class_name(max_length = 2048)
			buffer = '\0' * max_length
			length = get_class_name @handle, buffer, buffer.length
			length == 0 ? '' : buffer[0..length -1]
		end
	
		# Get the window handle of a child window or control.
		def child(id)
			@log.debug("id #{id} is frozen?: #{id.frozen?}")
			
			case id
			when String
				# Allow the user to use an underscore to specify an 
				# ampersand for the control name.
				by_title = find_window_ex @handle, 0, nil, id.gsub('_', '&')
				by_class = find_window_ex @handle, 0, id, nil
				if (by_title == 0 && by_class == 0)
					@log.debug("Did not find by title or class, recursing children")
					# @children = ChildRecurser.find_all_children(handle) if (@children == nil)
					# result = search_children(id)
					result = ChildEnumerator.find_child(handle, id)
					@log.debug("Found child #{result} for id #{id}") if (result > 0)
				else
					result = (by_title > 0) ? by_title : by_class
				end
			when Fixnum
				result = get_dlg_item @handle, id
			else
				result = 0
			end
	
			raise "Control '#{id}' not found" if result == 0
			Window.new result
		end

		# Click a button on a window
		def click(*args)
			# if no argument has been provided, click on the
			# window itself
			h = (args.length == 0) ? @handle : child(args[0]).handle
			
			rectangle = [0, 0, 0, 0].pack 'LLLL'
			get_window_rect h, rectangle
			left, top, right, bottom = rectangle.unpack 'LLLL'
			
			center = [(left + right) / 2, (top + bottom) / 2]
			set_cursor_pos *center
			
			mouse_event MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
			mouse_event MOUSEEVENTF_LEFTUP, 0, 0, 0, 0
		end

		# Locate the top level window for an application by either window
		# title or class ID.
		def self.top_level(title, wnd_class = nil, seconds=10)
		  @handle = timeout(seconds) do
			loop do
			  h = find_window wnd_class, title
			  break h if h > 0
			  sleep 0.3
			end
		  end
		
		  Window.new @handle
		end

		private

		# Search through child controls.
		# def search_children( id )
			# max_length = 2048
			# 
			# @log.debug("In search_children, id = #{id.gsub('_', '&').downcase}")
			# 
			# # Look for a match on the text or class of each child control.
			# @children.each_value do |control|
				# buffer = "\0" * 200
				# length = get_window_text(control.handle, buffer, 200)
				# text = (length == 0) ? '' : buffer[0..length -1]
# 
				# @log.info(" *** TEXT MISMATCH: (#{control.text}) (#{text})") if  (!control.text.eql?(text))
				# 
				# @log.debug("   #{control.handle}: #{control.text.downcase}, #{control.class_name.downcase}")
				# 
				# return control.handle if (id.gsub('_', '&').downcase == 
					# control.text.downcase)
				# return control.handle if (id.downcase ==
					# control.class_name.downcase)
			# end
			# return 0
		# end
	end

	# Handle a dialog box.
  DialogWndClass = '#32770'
  def dialog( title, seconds=3 )
	  close, dlg = begin
				w = Window.top_level(title, seconds, DialogWndClass)
				Window.set_foreground_window w.handle
				sleep 0.25
				
				[yield(w), w]
		rescue TimeoutError
			puts "Timed out finding top_level window."
		end

		dlg.wait_for_close if (dlg && close)
		return dlg
	end


	# Enumerate through the children of a window
	class ChildEnumerator
		include WindowsGui
		
		attr_reader :children

		# Define the EnumChildWindows API call.
		@@EnumChildWindows = Win32::API.new('EnumChildWindows', 'LKP', 
			'L', 'user32')
	
		def initialize
			@children = Hash.new
			
			@log = (Log4r::Logger['WindowsGui::ChildEnumerator']) ? 
				(Log4r::Logger['WindowsGui::ChildEnumerator']) : Log4r::Logger.new('WindowsGui::ChildEnumerator')
		end
		
		# Enumerate through children of the window_handle.
		def self.enum_children( window_handle )
			enumerator = ChildEnumerator.new
			enumerator.enum_children( window_handle )
			return enumerator.children
		end

		def enum_children( window_handle )
			@children.clear

			@log.debug("Finding children of handle #{window_handle}")

			enum_proc = Win32::API::Callback.new('L', 'I'){ |winHandle|
				@log.debug("Child #{winHandle}")
				@children[winHandle] = Window.new(winHandle) if (@children[winHandle] == nil)
				true
			}
			
			@@EnumChildWindows.call(window_handle, enum_proc, nil)
		end

		def self.find_child( window_handle, id, search_class = true )
			enumerator = ChildEnumerator.new
			enumerator.find_child( window_handle, id, search_class )
		end
			
		# Look for the specified window text or class in the children 
		# of the window_handle.
		def find_child( window_handle, id, search_class = true )

			matching_child = 0

			@log.debug("Searching for child #{id} in children of handle #{window_handle}")

			enum_proc = Win32::API::Callback.new('L', 'I'){ |winHandle|
				@log.debug("Child #{winHandle}")

				class_name = ''
				# Look for a match on the text or class of the  
				# child control.
				buffer = "\0" * 1024

				# length = get_window_text(winHandle, buffer, buffer.length)
				
				length = send_with_buffer(winHandle, WM_GETTEXT, buffer.length, buffer)
				text = (length == 0) ? '' : buffer[0..length -1]

				
				if (id.gsub('_', '&').downcase == text.downcase)
					# The control text matches
					@log.debug("   MATCHED on text: #{text}")
					matching_child = winHandle
				elsif (search_class)
					buffer = "\0" * 1024
					length = get_class_name winHandle, buffer, buffer.length
					class_name = (length == 0) ? '' : buffer[0..length -1]
					
					if (id == class_name)
						@log.debug("   MATCHED on class: #{class_name}")
						# The control class matches
						matching_child = winHandle
					end
				end

				@log.debug("   No match, text: #{text}, class: #{class_name}") if (matching_child == 0)
				
				(matching_child == 0)
			}
			
			@@EnumChildWindows.call(window_handle, enum_proc, nil)
			@log.debug("Enumeration complete, matching_child=#{matching_child}")

			matching_child
		end
	end
	
	# Recurses the child controls of a window handle to find all children.
	class ChildRecurser
		include WindowsGui
		
		attr_reader :allChildren

		# Define the EnumChildWindows API call.
		@@EnumChildWindows = Win32::API.new('EnumChildWindows', 'LKP', 
			'L', 'user32')
	
		def initialize
			@allChildren = Hash.new
			@childProcCalled = Hash.new
			@childrenToCall = Array.new
			
			@findTextOnly = false

			# procedure for printing control info for child controls.
			
			@PrintChildInfoProc = Win32::API::Callback.new('LL', 'I') { |winHandle, parent|
				if (@allChildren[winHandle] == nil)
					printControlInfo( parent, winHandle )
					@allChildren[winHandle] = 1
					@childrenToCall.push( winHandle )
				end
				true
		   }

			# procedure for printing control info for child controls.
			@GetChildHandleProc = Win32::API::Callback.new('L', 'I') { |winHandle|
				if (@allChildren[winHandle] == nil)
					@allChildren[winHandle] = Window.new(winHandle)
					@childrenToCall.push( winHandle )
				end
				true
		   }

		   @log = (Log4r::Logger['WindowsGui::ChildRecurser']) ? 
				(Log4r::Logger['WindowsGui::ChildRecurser']) : Log4r::Logger.new('WindowsGui::ChildRecurser')
		end

		# Recurse through children of the window_handle and print
		# information about them.
		def print_all_children( window_handle, findTextOnly = false )
			@findTextOnly = findTextOnly
			
			# Process the parent window.
			if (@allChildren[window_handle] == nil)
				printControlInfo( 0, window_handle )
				@allChildren[window_handle] = 1
			end
	
			# Enumerate the control's children.
			if (@childProcCalled[window_handle] == nil)
				# Enumeration has not been called on this control, so call it.
				@@EnumChildWindows.call(window_handle, @PrintChildInfoProc,
					window_handle)
				@childProcCalled[window_handle] = 1
				
				# While the array of children to call is not empty, recurse
				# children.
				while (@childrenToCall.first != nil)
					handle = @childrenToCall.shift
					print_all_children( handle )
				end
			end
		end

		# Recurse through children of the window_handle.
		def self.find_all_children( window_handle )
			recurser = ChildRecurser.new
			recurser.find_all_children( window_handle )
			return recurser.allChildren
		end

		# Recurse through children of the window_handle.
		def find_all_children( window_handle )

			@log.debug("Finding all children for handle #{window_handle}")
			
			# Process the parent window.
			if (@allChildren[window_handle] == nil)
				@allChildren[window_handle] = Window.new(window_handle)
			end
	
			# Enumerate the control's children.
			if (@childProcCalled[window_handle] == nil)
				# Enumeration has not been called on this control, so call it.
				@@EnumChildWindows.call(window_handle, @GetChildHandleProc, nil)
				
				@childProcCalled[window_handle] = 1
				
				# While the array of children to call is not empty, recurse
				# children.
				while (@childrenToCall.first != nil)
					handle = @childrenToCall.shift
					find_all_children( handle )
				end
			end
		end

	private
	
		def printControlInfo(parent, winHandle)
			# The control has not been processed yet, so process it.
			text = "\0" * 200
			clss = "\0" * 200
			get_window_text(winHandle, text, 200)
			get_class_name(winHandle, clss, 200)
	
			if (@findTextOnly)
				puts "#{parent}\t#{winHandle}\t#{text.strip}\t#{clss.strip}" if (text.strip.length > 0)
			else
				puts "#{parent}\t#{winHandle}\t#{text.strip}\t#{clss.strip}"
			end
		end
		
	end

end


