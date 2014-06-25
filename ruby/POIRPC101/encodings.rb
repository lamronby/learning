# coding: utf-8
#
# in Ruby 1.9 only 
# A string literal containing a multibye character 
s = "José" 
# The string contains 5 bytes which encode 4 characters
puts 'String: ' + s
puts s.length    # => 4 
puts s.bytesize # => 5 
