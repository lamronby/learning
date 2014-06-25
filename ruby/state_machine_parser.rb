=begin
	state_table_parser - Convert state table from code to a tab-delimited table
	                     and vice versa.

	Expected code structure:
		1:  comment (optional)
		2:  state names, tab delimited
		3:  <event ID><tab><event name><tab><state1_action><tab><state2_action>
		
		
	Example:
		1:  Comment (optional)
		2:		  AtState1	AtState2	AtState3	AtState4
		3:	E0	OnEv1	DoThing	DoThing2	DoThing3	invalid
		4:	E1	OnEv2	DoThing5	ToAtState3	invalid	invalid
	
	Recognized state action variations:
		No action:    [] {}
		Invalid:      invalid [invalid]
		To new state: To<state> [To<state>] <state> [<state>]
=end

require 'log4r'

include Log4r

if __FILE__ == $0

    if (ARGV.length == 0)
        puts "\n\tUsage: decisionator <filename>\n"
        exit 1
    end

    # Get the root logger and set its level to DEBUG. This makes the global
    # level WARN.
    Logger.root.level = Log4r::DEBUG

    # Specify logging output format
    format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    StdoutOutputter.new('console', :formatter => format)
    
    log = Logger.new('decisionator')
    log.add('console')
    
end


