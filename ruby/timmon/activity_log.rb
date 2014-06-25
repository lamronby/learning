=begin
 A collection of logged activities.
=end

require 'activity'
require 'rexml/document'
require 'log4r'

include Log4r

class ActivityLog
    # TODO Consider moving.
    # Define element keys
    ACTIVITY_ELEM = "LogEntry"
    ACTIVITY_ID_ELEM = "id"
    ACTIVITY_PERIOD_ELEM = "period"
    ACTIVITY_NOTE_ELEM = "note"
    TASK_ELEM = "task"
    TASK_ID_ELEM = "id"

    # def initialize(min, max, *other_args)
        # @ratings = Ratings.new(min, max)
        # 
        # # Problem statement
        # if (other_args[0])
            # @problem = other_args[0] if (other_args[0].kind_of? Problem)
        # end
        # 
        # # Solution(s).
        # if (other_args[1])
            # # If this is an array, set the instance variable to the array.
            # # Otherwise, create a new array.
            # @solutions = (other_args[1].is_a? Array) ? other_args[1] :
                # [other_args[1]]
        # end
        # 
        # # create a logger
        # @log = Logger.new("decisionator::decision")
    # end
    
    # Read activity information from XML.
    def self.read_file(file)
        doc = REXML::Document.new(file)
        
        @@log = Logger.new("timmon::task_log")
        @@log.debug("Reading the file.")

        root = doc.root

        # Parse the set of activities
        activities = Hash.new
        parent = nil
        @@log.debug("Log entries: #{root.elements}")
        root.elements.each(ACTIVITY_ELEM) do |activity|
            id = activity.attributes[ACTIVITY_ID_ELEM]
            category_id = activity.elements[TASK_ELEM].attributes[TASK_ID_ELEM]
            period = activity.elements[ACTIVITY_PERIOD_ELEM].text
            if (activity.elements[ACTIVITY_NOTE_ELEM])
                note = activity.elements[ACTIVITY_NOTE_ELEM]
            end
            
            @@log.debug("Parsing activity #{id}, period: #{period}")

            activities[id] = Activity.new(id, category_id, period, note)
    
        end

        # Return the parsed activities.
        activities
    end

    attr_reader :activities
    
end

