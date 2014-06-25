=begin
 Given a user story CSV export from Rally, convert it to a Task Coach file.
=end

require 'CSV'
require 'rexml/document'

include REXML

class Date
    def self.now
        # I like Time#now, this should have been included into Date
        self.new(Time.now.year,Time.now.month,Time.now.day)
    end
end

if __FILE__ == $0

    if (ARGV.count == 0)
        print "\nUsage: RallyExport2TaskCoach.rb <rally_export_file>\n"
        exit
    end


    infile = ARGV[0]
    #infile = "C:/Users/cjansen/Downloads/export(3).csv"
    
    # Create new XML document.
    doc = Document.new
    
    root_node = Element.new 'tasks'
    
    doc.add_element root_node
    
    now = Date.now
    
    # Create new XML file.
    newfile = File.basename(infile, ".*") + ".tsk"
    puts "New XML File = #{newfile}"
    
    CSV.foreach(infile, :headers => true) do |record|

        #"Formatted ID","Name","Work Product","Release","Iteration","Scheduled State","Estimate","Task Remaining Total","Actuals","Owner"
        #"TA4742","Define operation contracts","US1021: Agent - new operations for loading and saving layouts, location of modules","Production Release - DLS v2.5 (Phoenix) CSS Delivery Platform & Suite","Iteration #1 - Requirements Documentation for DLS v2.5 CSS Suite","Defined","2.0","2.0","","chris.jansen@troppussoftware.com"
        
        # <task budget="3:00:00" completiondate="2009-11-12" expandedContexts="('taskviewer',)" id="67566320:1257974330.05" percentageComplete="100" startdate="2009-11-11" status="1" subject="TA3254: Create symptoms services">
        # ID + Name     => task/@subject
        # Work Product  => Parent Task
        # Release => 
        # Estimate => Task/@budget
        puts "Parsing #{record}"
        
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
        task.add_attribute "subject", (record["Formatted ID"] + " " + record["Name"])
        # if (record.field?("Estimate"))
        #     budget = record["Estimate"]
        # end
        # task.add_addribute "budget", record["Estimate"]
        
        task_story << task   
    end
    
    # Add XML declaration
    doc << XMLDecl.new
    
    # Write to stdout and the target output file.
    doc.write( $stdout, 2 )
    File.open(newfile, 'wb') {|filep| doc.write(filep, 2)}
end

