=begin
Write some code that can be used in a templating engine.
This should take a map of variables ("day" => "Thursday", "name" 
=> "Billy") as well as a string
template ("${name} has an appointment on ${Thursday}") and 
perform substitution as needed.

This needs to be somewhat robust, throwing some kind of error if 
a template uses a variable that has not
been assigned, as well as provide a way to escape the strings 
("hello ${${name}}" -> "hello ${Billy}")
=end


if __FILE__ == $0

# Define command-line arguments
#opts = OptionParser.new
#opts.on("-t") {in_test_mode = true}
#opts.on("-lARG", Integer) {|val| start_line=val}

#other_args = opts.parse(ARGV)

# First command-line argument after options
#first_arg = other_args[0]


    
end


