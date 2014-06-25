# p073prclient.rb
require 'soap/rpc/driver'
driver = SOAP::RPC::Driver.new('http://www.rubylearning.com:12321/', 'urn:mySoapServer')
driver.add_method('sayhelloto', 'username')
puts driver.sayhelloto('RubyLearning')
