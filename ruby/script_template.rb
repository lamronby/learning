=begin
	<script_name> - <description>
=end

require 'log4r'
#require 'optparse'

include Log4r

if __FILE__ == $0

# Define command-line arguments
#opts = OptionParser.new
#opts.on("-t") {in_test_mode = true}
#opts.on("-lARG", Integer) {|val| start_line=val}

other_args = opts.parse(ARGV)

# First command-line argument after options
first_arg = other_args[0]


    # Get the root logger and set its level.
    Logger.root.level = Log4r::DEBUG

    # Specify logging output format.
    format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    
    log = Logger.new(<script_name>)

	# Set up logging to use the console unless a log file is provided on the
	# command-line.
	if (other_args[1])
		Log4r::FileOutputter.new('logfile', 
							 :filename=>other_args[1],
							 :formatter=>format,
							 :trunc=>false,
							 :level=>Log4r::DEBUG)
		log.add('logfile')
	else
		# Create an outputter for $stderr.
		StderrOutputter.new('console', :formatter=>format, :level=>Log4r::INFO)
		# StdoutOutputter.new('console', :formatter => format)
		log.add('console')
	end

    
end


