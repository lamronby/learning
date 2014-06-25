=begin
 Encapsulates all information for a task. Activities can then be tracked
 for a task.
=end

require 'activity'
require 'rexml/document'
require 'log4r'

include Log4r

class Task
    # Define element keys
    ROOT_ELEM = "task"
    ID_ELEM = "task_id"
    NAME_ELEM = "title"
    DESCRIPTION_ELEM = "note"

    def initialize(name, id, *other_args)
        @name = name
        @id = id
        @description = ''
        @max_time = 0
        
        # Description
        @description = other_args[0] if (other_args[0])

        # max time
        @max_time = other_args[1] if (other_args[1])

        # parent
        @parent = other_args[2] if (other_args[2])  
        
        # create a logger
        @log = Logger.new('timmon::task_category')

        # Initialize activity array
        @activities = Array.new

        # Initialize the total duration
        @total_duration = 0
    end

    # Add a new activity
    def add_activity(new_activity)
        if (new_activity.task_id != @id)
            raise "The activity is not for this task."
            return
        end

        activities.push(new_activity)
        @total_duration += new_activity.duration

        @log.debug("#{@name}: added activity #{new_activity.id}, duration= #{new_activity.duration}, total duration=#{@total_duration}")
    end
    
    def to_s
        output = format("Task id %3d: %s", @id, @name)
        output << " (#{@description})" if (@description.length > 0)
        output << " max time: #{@max_time}" if (@max_time > 0)
        output << " parent: #{@parent.name}" if @parent
        output
    end
    
    attr_reader :id, :name, :description, :max_time, :parent, :total_duration, :activities 
    
end

