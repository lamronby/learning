
require 'CSV'
require 'rexml/document'

include REXML

class Date
    def self.now
        # I like Time#now, this should have been included into Date
        self.new(Time.now.year,Time.now.month,Time.now.day)
    end
end
      
#print "CSV file to read: "
#infile = gets.strip
infile = "C:/Users/cjansen/Downloads/export(3).csv"

#print "What do you want to call each element: "
#record_name = gets.strip
record_name = "A"

#print "What do you want to title the XML document: "
#title = gets.strip
title = "B"

#print "What do you want to call the set of elements: "
#set = gets.strip
set = "C"

doc = Document.new

root_node = Element.new 'tasks'

doc.add_element root_node

now = Date.now

# New XML file
newfile = File.basename(infile, ".*") + ".xml"
    puts "New XML File = #{newfile}"

#File.open(newfile, 'wb') do |ofile|
#  ofile.puts "\t<name>#{title}</name>"
  CSV.foreach(infile, :headers => true) do |record|
    #"ID","Name","Work Product","Release","Iteration","Scheduled State","Estimate","To Do","Actuals","Owner"
    #"TA1471","Implement role membership provider","US407: Services authorization: Secure services based on user security resource authorization","","","Defined","4.0","4.0","","chris.jansen@troppussoftware.com"

    # <task budget="3:00:00" completiondate="2009-11-12" expandedContexts="('taskviewer',)" id="67566320:1257974330.05" percentageComplete="100" startdate="2009-11-11" status="1" subject="TA3254: Create symptoms services">
    # ID + Name     => task/@subject
    # Work Product  => Parent Task
    # Release => 
    # Estimate => Task/@budget
    subject = record["Work Product"]

    task_story = root_node.elements["task[@subject='#{subject}']"]
    if (!task_story)
        task_story = Element.new 'task'
        task_story.add_attribute "subject", record["Work Product"]
        task_story.add_attribute "startdate", now.to_s
        root_node << task_story
    end

    task = Element.new 'task'
    task.add_attribute "startdate", now.to_s
    task.add_attribute "subject", (record["ID"] + " " + record["Name"])
    # if (record.field?("Estimate"))
    #     budget = record["Estimate"]
    # end
    # task.add_addribute "budget", record["Estimate"]

    task_story << task
   
#     ofile.puts "\t<#{record_name}>"
#     #for i in 0..(header.size - 1)
#     for r in record
#       puts r.inspect
#       ofile.puts "\t\t<#{r[0]}>#{r[1]}</#{r[1]}>"
#     end
#     ofile.puts "\t</#{record_name}>"
   end
#   ofile.puts "</#{set}>"

#end

#puts doc

# Add XML declaration
doc << XMLDecl.new

doc.write( $stdout, 2 )
File.open(newfile, 'wb') {|filep| doc.write(filep, 2)}
