#---
# Excerpted from "Scripted GUI Testing With Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/idgtr for more book information.
#---

require 'Win32API'
require 'timeout'

def user32(name, param_types, return_value) #(1)
  Win32API.new 'user32', name, param_types, return_value
end

# HWND FindWindow(LPCTSTR windowClass, LPCTSTR title);
find_window = user32 'FindWindow', ['P', 'P'], 'L'

system 'start "" "D:/Tools/LockNote 1.0.3/LockNote.exe"'

sleep 0.2 while (main_window = find_window.call \
  nil, 'LockNote - Steganos LockNote') <= 0  #(2)

puts "The main window's handle is #{main_window}."

# void keybd_event(
#   BYTE keyCode,
#   BYTE unused,
#   DWORD event,
#   DWORD extraInfo);

keybd_event = user32 'keybd_event', ['I', 'I', 'L', 'L'], 'V'

KEYEVENTF_KEYDOWN = 0 
KEYEVENTF_KEYUP = 2 

# "several species of small furry animals gathered together and grooving with a pict".upcase.each_byte do |b| #(3)
"this is some text".upcase.each_byte do |b| #(3)
  keybd_event.call b, 0, KEYEVENTF_KEYDOWN, 0 
  sleep 0.03 
  keybd_event.call b, 0, KEYEVENTF_KEYUP, 0 
  sleep 0.03 
end 

# BOOL PostMessage(
#   HWND window,
#   UINT message,
#   WPARAM wParam,
#   LPARAM lParam);
post_message = user32 'PostMessage', ['L', 'L', 'L', 'L'], 'I'

WM_SYSCOMMAND = 0x0112 
SC_CLOSE = 0xF060

post_message.call main_window, WM_SYSCOMMAND, SC_CLOSE, 0 

# You might need a slight delay here.
sleep 0.5

# HWND GetDlgItem(HWND dialog, int control);
get_dlg_item = user32 'GetDlgItem', ['L', 'L'], 'L' 

dialog = timeout(3) do                    #(4)
  sleep 0.2 while (h = find_window.call \
    nil, 'Steganos LockNote') <= 0; h #(5)
end

IDNO = 7
button = get_dlg_item.call dialog, IDNO 

# BOOL GetWindowRect(HWND window, LPRECT rectangle)
get_window_rect = user32 'GetWindowRect', ['L', 'P'], 'I' 

rectangle = [0, 0, 0, 0].pack 'L*'
get_window_rect.call button, rectangle 
left, top, right, bottom = rectangle.unpack 'L*'

puts "The No button is #{right - left} pixels wide and #{bottom - top} pixels high." #(6)


set_cursor_pos = user32 'SetCursorPos', ['L', 'L'], 'I' 

mouse_event = user32 'mouse_event', ['L', 'L', 'L', 'L', 'L'], 'V' 

MOUSEEVENTF_LEFTDOWN = 0x0002 
MOUSEEVENTF_LEFTUP = 0x0004

center = [(left + right) / 2, (top + bottom) / 2]

set_cursor_pos.call *center #(7)

mouse_event.call MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0 
mouse_event.call MOUSEEVENTF_LEFTUP, 0, 0, 0, 0 


