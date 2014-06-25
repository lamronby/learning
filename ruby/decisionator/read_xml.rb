
require "rexml/document"

file = File.new( "mydoc.xml" )
doc = REXML::Document.new file

doc.elements.each("inventory/section") { |element| puts  element.attributes["name"] }
# -> health
# -> food
doc.elements.each("*/section/item") { |element| puts element.attributes["upc"] }
# -> 123456789
# -> 445322344
# -> 485672034
# -> 132957764

root = doc.root
puts root.attributes["title"]
# -> OmniCorp Store #45x10^3
puts root.elements["section/item[@stock='44']"].attributes["upc"]
# -> 132957764
puts root.elements["section"].attributes["name"] 
# -> health (returns the first encountered matching element) 
puts root.elements[1].attributes["name"] 
# -> health (returns the FIRST child element) 
root.detect {|node| node.kind_of? Element and node.attributes["name"] == "food" }
