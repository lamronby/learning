=begin
Exercise1. Write a program that processes a string s = "Welcome to the forum.\nHere you can learn Ruby.\nAlong with other members.\n" a line at a time, using all that we have learned so far. The expected output is:

>ruby tmp.rb
Line 1: Welcome to the forum.
Line 2: Here you can learn Ruby.
Line 3: Along with other members.
>Exit code: 0
=end

s = "Welcome to the forum.\nHere you can learn Ruby.\nAlong with other members.\n"

lines = s.split(/\n/)

x = 1
lines.each do |line|
    puts "Line #{x}: #{line}"
    x += 1
end
