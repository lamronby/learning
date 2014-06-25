=begin
 Timmon parser console front-end
=end

# add the path to rexml
$: << 'C:/ruby/lib/ruby/1.8'
# add the path to log4r
$: << 'C:/ruby/lib/ruby/gems/1.8/gems/log4r-1.0.5/src'

require 'task'
require 'task_map'
require 'activity'
require 'activity_log'

# Print activity data in a CSV format.
def print_activities_csv(activities, tasks)
    if (activities.size > 0)
        puts "activity_id,parent_task,task,start,end,duration,note"
        activities.each_key do |key|
            # CSV format:
            # <activity_id>,<parent>,<task>,<start>,<end>,<duration>,<note>
            activity = activities[key]
            task_id = activity.task_id
            if (!tasks.key?(task_id))
                puts "Task ID #{task_id} not found in task list!"
                next
            end
            task_name = tasks[task_id].name
        
            # If a parent task exists, get its name.
            parent_task = (tasks[task_id].parent == nil) ? "none" :
                tasks[task_id].parent.name

            time_format = "%m/%d/%Y %H:%M:%S"
            fmt_start = activity.start.strftime(time_format)
            fmt_end = activity.end.strftime(time_format)
            puts "#{activity.id},#{parent_task},#{task_name},#{fmt_start},#{fmt_end},#{activity.duration},#{activity.note}"
        end
    end
end

# Print task data in a CSV format.
def print_tasks_csv(tasks)
    if (tasks.size > 0)
        puts "Parent Task,Task,Total Duration"
        tasks.each_key do |key|
            next if (tasks[key].total_duration == 0)
            # If a parent task exists, get its name.
            parent_task = (tasks[key].parent == nil) ? "none" :
                tasks[key].parent.name
            duration_mins = (tasks[key].total_duration / 60) 
            puts "#{parent_task},#{tasks[key].name},#{duration_mins}"
        end
    end
end

# Parse a date. The method will throw an ArgumentException if the date
# cannot be parsed.
def parse_date(date_str)
    new_date = Date.parse(date_str)
end

if __FILE__ == $0

    # TODO Figure out a way to specify defaults
    @@TASKS_FILENAME = 'c:\Users\cjansen\.timmon\tasktree.xml'
    @@ACTIVITIES_FILENAME = 'c:\Users\cjansen\.timmon\tasklog.xml'
    
    if (ARGV.length < 1 || ARGV.length == 2 || ARGV.length > 3)
        puts "\n  Usage: timmon_parser [task_filename] [activity_filename] <date>"
        puts "            task_filename:     The name of the XML file containing the task"
        puts "                               hierarchy"
        puts "            activity_filename: The name of the XML file containing a collection" 

        puts "                               of activities"
        puts "            date:              The date for which to report"
        exit 1
    end

    task_filename = @@TASKS_FILENAME
    activities_filename = @@ACTIVITIES_FILENAME
    
    if (ARGV.length == 3)
        task_filename = ARGV.shift
        activities_filename = ARGV.shift
    end
    
    if (!File.exist?(task_filename))
        puts "Sorry, file #{task_filename} does not exist."
        exit 1
    end
    
    if (!File.exist?(activities_filename))
        puts "Sorry, file #{activities_filename} does not exist."
        exit 1
    end

    # Get the root logger and set its level.
    Logger.root.level = Log4r::ERROR

    # Specify logging output format
    #format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    format = PatternFormatter.new(:pattern => "%d [%5l] - %m")
    StdoutOutputter.new('console', :formatter => format)
    
    log = Logger.new('timmon')
    log.add('console')

    date_str = ARGV.shift
    begin
        target_date = parse_date(date_str)
    rescue ArgumentError
        puts "ERROR: Could not parse entered date (#{date_str})"
        exit 1
    end

    log.info("Entered date: #{target_date}")
    
    log.info("Reading task file #{task_filename}")
    xml_file = File.new(task_filename)

    my_tasks = TaskMap.read_file(xml_file)
    my_tasks.each_key {|key| log.debug(my_tasks[key].to_s)} 

    log.info("Reading activities file #{activities_filename}")
    xml_file = File.new(activities_filename)

    my_activities = ActivityLog.read_file(xml_file)
    my_activities.each_key {|key| log.debug(my_activities[key].to_s)}

    if (my_activities.size > 0)
        my_activities.each_key do |key|
            activity = my_activities[key]
            task_id = activity.task_id
            if (!my_tasks.key?(task_id))
                puts "Task ID #{task_id} not found in task list!"
                next
            end
            if (activity.start.jd == target_date.jd || 
                activity.end.jd == target_date.jd)
                log.debug("Activity date matches target date.")
                my_tasks[task_id].add_activity(activity)
            end
        end
    end
    
    print_tasks_csv(my_tasks)
end


