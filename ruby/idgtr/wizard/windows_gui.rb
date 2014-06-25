=begin
 Windows GUI modules. Provides method wrappers for Win32 API calls.
=end

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


require 'Win32API'
require 'timeout'

module WindowsGui

	# Add Win32API methods directly to the WindowGui module.
	def self.def_api(function, parameters, return_value, rename = nil)
		api = Win32API.new 'user32', function, parameters, return_value

		define_method(function.snake_case) do |*args|
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
	def_api 'FindWindow', ['P', 'P'], 'L'
	def_api 'FindWindowEx', ['L', 'L', 'P', 'P'], 'L'
	
	def_api 'SendMessage', ['L', 'L', 'L', 'P'], 'L', :send_with_buffer
	def_api 'SendMessage', ['L', 'L', 'L', 'P'], 'L'
	
	# BOOL PostMessage( HWND window, UINT message, WPARAM wParam, 
	#                   LPARAM lParam);
	def_api 'PostMessage', ['L', 'L', 'L', 'L'], 'I'
	
	# void keybd_event( BYTE keyCode, BYTE unused, DWORD event, 
	#                   DWORD extraInfo);
	def_api 'keybd_event', ['I', 'I', 'L', 'L'], 'V'
		
	# HWND GetDlgItem(HWND dialog, int control);
	def_api 'GetDlgItem', ['L', 'L'], 'L'
	
	# BOOL GetWindowRect(HWND window, LPRECT rectangle)
	def_api 'GetWindowRect', ['L', 'P'], 'I'

	# int GetWindowText(HWND hWnd, LPTSTR lpString, int nMaxCount)
	def_api 'GetWindowText', ['L', 'P', 'L'], 'L'

	# int GetClassName(HWND hWnd, LPTSTR lpClassName, int nMaxCount)
	def_api 'GetClassName', ['L', 'P', 'L'], 'L' 

	def_api 'SetCursorPos', ['L', 'L'], 'I' 
	def_api 'mouse_event', ['L', 'L', 'L', 'L', 'L'], 'V' 

	def_api 'IsWindow', ['L'], 'L'
	def_api 'IsWindowVisible', ['L'], 'L'

	def_api 'SetForegroundWindow', ['L'], 'L'

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

	
	# Send a keystroke.
	def keystroke(*keys)
		#valchk
		return if keys.empty?

		keybd_event keys.first, 0, KEYEVENTF_KEYDOWN, 0
		sleep 0.05
		keystroke *keys[1..-1]
		sleep 0.05 
		keybd_event keys.first, 0, KEYEVENTF_KEYUP, 0
	end

	# Type in a string.
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

	# Handle a dialog box.
	def dialog( title, seconds=3 )
		d = begin
				w = Window.top_level(title, seconds)
				yield(w) ? w : nil
		rescue TimeoutError
		end

		d.wait_for_close if d
		return d
	end

	class Window
		include WindowsGui
		extend WindowsGui

		attr_reader :handle

		def initialize(handle)
			@handle = handle
		end

		def close
			post_message @handle, WM_SYSCOMMAND, SC_CLOSE, 0
		end

		def wait_for_close
			timeout(5) do
				sleep 0.2 until 0 == is_window_visible(@handle)
			end
		end

		def text
			buffer = '\0' * 2048
			length = send_message @handle, WM_GETTEXT, buffer.length, buffer
			length == 0 ? '' : buffer[0..length -1]
		end

		def class_name
			buffer = '\0' * 2048
			length = get_class_name @handle, buffer, buffer.length
			length == 0 ? '' : buffer[0..length -1]
		end

		# Get the window handle of a child window or control.
		def child(id)
			case id
			when String
				# Allow the user to use an underscore to specify an ampersand for
				# the control name.
				by_title = find_window_ex @handle, 0, nil, id.gsub('_', '&')
				by_class = find_window_ex @handle, 0, id, nil
				result = (by_title > 0) ? by_title : by_class
			when Fixnum
				result = get_dlg_item @handle, id
			else
				result = 0
			end
	
			raise "Control '#{id}' not found" if result == 0
			Window.new result
		end
	
		
		# Click a button on a window
		def click(id)
			h = child(id).handle
			
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
			puts "Looking for window with title #{title}, class #{wnd_class}"
			@handle = timeout(seconds) do
			loop do
			  h = find_window wnd_class, title
			  puts "find_window returned #{h}"
			  break h if h > 0
			  sleep 0.3
			end
		  end
	
		  Window.new @handle
		end
	end
end


