

require 'win32/api'
include Win32

# Windows messages - text
WM_GETTEXT = 0x000D
	
def get_text(handle)
    buffer ='\0' * 1024
    SendMessage.call(handle, WM_GETTEXT, buffer.length, buffer)
    return buffer.strip
end

#-- nSight Central -------------------------------
system 'start "" "D:\\Projects\\Raptor\\Plus\\v5.0\\Output\\nSightCentral.exe"'

FindWindow =   Win32::API.new('FindWindow', 'PP', 'L', 'user32')
FindWindowEx = Win32::API.new('FindWindowEx', 'LLPP', 'L', 'user32')
SendMessage =  Win32::API.new('SendMessage', 'LLLP', 'L', 'user32')

sleep 5

mainWindow = FindWindow.call(nil, "nSight Central")
puts "Main window handle is #{mainWindow}"
if (mainWindow > 0)
	child_window = FindWindowEx.call(mainWindow, 0, nil, nil)
	puts "child_window is #{child_window}"
	while (child_window > 0)
		puts "child_window: #{child_window}, text=#{get_text(child_window)}\n" 
	
	#    child_window = FindWindowEx.call(main_window.handle, child, nil, nil)
	end
end

	# Define the EnumChildWindows API call.
	# EnumChildWindows = Win32::API.new('EnumChildWindows', 'LKP', 
		# 'L', 'user32')
	# 
	# # procedure for printing control info for child controls.
	# GetChildHandleProc = Win32::API::Callback.new('L', 'I') { |winHandle|
		# if (@allChildren[winHandle] == nil)
			# @allChildren[winHandle] = Window.new(winHandle)
			# @childrenToCall.push( winHandle )
		# end
		# true
   # }

# child_window = main_window.child( "e&xit" ) 
# if (child_window.handle > 0)
	# puts "child_window: #{child_window}, class_name=#{child_window.class_name}"
# else
	# puts "Exit control not found."
# end

	# child_window = FindWindowEx.call(main_window.handle, 0, nil, "e&xit")
	# if (child_window > 0)
		# puts "child_window: #{child_window}, class_name=#{child_window.class_name}" 
	# else
		# puts "Exit control not found." 
	# end

