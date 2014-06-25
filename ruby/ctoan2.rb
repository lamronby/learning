=begin
 log4r test
=end

require 'log4r'
include Log4r

# Get the root logger and set its level to DEBUG. This makes the global
# level WARN.
Logger.root.level = Log4r::DEBUG

format = PatternFormatter.new(:pattern=>"%d [%l] (%c) - %m")
StdoutOutputter.new('console', :formatter=>format)
#Log4r::StdoutOutputter.new ('console')

log1 = Logger.new('decisionator')
log1.add('console')

log1.debug("Test message 1 for decisionator.")

# Log4r::Logger.root.add('console')
log2= Logger.new('decisionator::test_solution')

log2.debug("Test message 1 for decisionator::test_solution.")

while gets
    puts "You just typed #{$_}"
end


