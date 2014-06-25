
require 'rexml/document'
require 'date'

class Date
    def self.now
        # I like Time#now, this should have been included into Date
        self.new(Time.now.year,Time.now.month,Time.now.day)
    end
end
      
include REXML

doc = Document.new

doc << XMLDecl.default

taskEl = Element.new 'tasks'

doc << taskEl

puts doc.to_s

now = Date.now

puts now.to_s

