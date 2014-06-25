
system 'start "" "D:/Tools/LockNote 1.0.3/LockNote.exe"'

find_window = Win32API.new 'user32', 'FindWindow', ['P', 'P'], 'L'

handle = find_window.call nil, 'LockNote'

puts "Done!"
