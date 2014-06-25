require 'soap/rpc/driver'
driver = SOAP::RPC::Driver.new(
  'http://www.swanandmokashi.com/HomePage/WEBSERVICES/QuoteOfTheDay.asmx',
	's0:QuoteOfTheDaySoap')
driver.add_method('GetQuote')
puts driver.GetQuote

