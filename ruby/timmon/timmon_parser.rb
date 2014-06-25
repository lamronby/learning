=begin
 Timmon parser console front-end. The Timmon parser takes Timmon XML data
 and allows the user to extract data for a specific date or date range.
=end

# add the path to rexml
$: << 'C:/ruby/lib/ruby/1.8'
# add the path to log4r
$: << 'C:/ruby/lib/ruby/gems/1.8/gems/log4r-1.0.5/src'
# add the path to jfreechart
$: << 'D:/Tools/jfreechart-1.0.9/lib'

include Java

require 'task'
require 'task_map'
require 'activity'
require 'activity_log'
require 'date'

require 'jfreechart-1.0.9.jar'
require 'jcommon-1.0.12.jar'

import org.jfree.chart.ChartFactory
import org.jfree.chart.ChartUtilities
import org.jfree.chart.JFreeChart
import org.jfree.data.general.DefaultPieDataset
import javax.swing.JFrame
import javax.swing.JLabel
import javax.swing.ImageIcon

#
# Helper methods for determining command-line options and parsing
# Timmon data.
#
class TimmonParser
    TASKS_FILENAME = 'c:\Users\cjansen\.timmon\tasktree.xml'
    ACTIVITIES_FILENAME = 'c:\Users\cjansen\.timmon\tasklog.xml'

    # Print activity data in a CSV format.
    
    def self.print_activities_csv(activities, tasks)
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
    def self.print_tasks_csv(tasks)
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
    
    #
    # Parse a date. The method will throw an ArgumentException if the date
    # cannot be parsed.
    # For ambiguous dates (examples below), the date is always assumed to be
    # in the past.
    # Valid values for a date:
    #   today or tod     - current day
    #   yesterday 
    #   or yst           - yesterday
    #   10               - the day-of-the-month. If the current day-of-month
    #                      is greater than the month entered, use the current 
    #                      month, otherwise assume the previous month
    #   10/5 	         - a specific date. If date is after the current date,
    #                      assume this year, otherwise assume previous year
    #   10/5/2006 	     - a specific date including year
    #   friday or fri 	 - the previous appropriate day-of-the-week
    #
    def self.parse_date(date_str)
        days_of_week = ['sunday', 'monday', 'tuesday', 'wednesday', 
                        'thursday', 'friday', 'saturday']
        days_of_week_abbr = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']
    
        begin
            # First, see if the Date parse method can parse the date.
            Date::parse(date_str)
        rescue ArgumentError => err
            # The date couldn't be parsed, so check for other possibilities.
            if (['today', 'tod'].include?(date_str))
                Date.today()
            elsif (['yesterday', 'yst'].include?(date_str))
                Date.today() - 1
            elsif (days_of_week.include?(date_str))
                # The user entered a day of the week (e.g. friday).
                # Do some date math using a numeric day of the week (Sunday=0).
                target_day = days_of_week.index(date_str)
                current_day = Date.today().jd_to_wday
                parse_day_of_week(current_day, target_day)
            elsif (days_of_week_abbr.include?(date_str))
                # The user entered an abbreviated day of the week (e.g. fri).
                # Do some date math using a numeric day of the week (Sunday=0).
                target_day = days_of_week_abbr.index(date_str)
                current_day = Date.today().jd_to_wday
                parse_day_of_week(current_day, target_day)
            else
                raise err
            end
        end
    end

    def self.usage
#       puts "\n  Usage: timmon_parser [task_filename] [activity_filename] <date> [end_date]"
#        puts "            task_filename:     The name of the XML file containing the task"
#        puts "                               hierarchy"
#        puts "            activity_filename: The name of the XML file containing a collection" 

#        puts "                               of activities"
        puts "\n  Usage: timmon_parser [-h num] <date> [end_date]"
        puts "          -h num:              num is the number of hours to assume"
        puts "                               for each day. If this argument is"
        puts "                               provided, the parser will fill any"
        puts "                               extra time for the day with an activity"
        puts "                               named 'unspecified'"
        puts "            date:              The date for which to report, or"
        puts "                               the start date for a date range"
        puts "            end_date:          The end date for a date range"
    end

    def self.display_chart(image)
        frame = JFrame.new("Pie Chart")
        label_chart = JLabel.new()
        label_chart.setIcon(ImageIcon.new(image))
        
        # Add the label to the frame
        frame.get_content_pane.add(label_chart)
        
        # Show frame
        frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
        frame.pack
        frame.visible = true        
    end
    
    private
    #
    # Convert a day-of-the-week (e.g. friday) to a date. If the
    # day is earlier than the current day, return the date for the day
    # in the current week. If the day is later than the current day, return 
    # the date for the day in the previous week.
    #
    def self.parse_day_of_week(current_day, target_day)
        if (target_day < current_day)
            # The day is earlier in the current week.
            diff = current_day - target_day 
            Date.today() - diff
        elsif (target_day > current_day)
            # The day is after the current day, so return the day
            # for the previous week.
            diff = (current_day - 7) + target_day
            Date.today() - diff
        else
            Date.today()
        end
    end

end

if __FILE__ == $0

    # TODO Figure out a way to specify defaults
    
    if (ARGV.length < 1 || ARGV.length > 2)
        usage
        exit 1
    end

    task_filename = TimmonParser::TASKS_FILENAME
    activities_filename = TimmonParser::ACTIVITIES_FILENAME
    
    # if (ARGV.length >= 3)
        # task_filename = ARGV.shift
        # activities_filename = ARGV.shift
    # end
    
    if (!File.exist?(task_filename))
        puts "Sorry, file #{task_filename} does not exist."
        exit 1
    end
    
    if (!File.exist?(activities_filename))
        puts "Sorry, file #{activities_filename} does not exist."
        exit 1
    end

    # Get the root logger and set its level.
    Logger.root.level = Log4r::INFO

    # Specify logging output format
    #format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    format = PatternFormatter.new(:pattern => "%d [%5l] - %m")
    StdoutOutputter.new('console', :formatter => format)
    
    log = Logger.new('timmon')
    log.add('console')

    # Parse the date, which is either the first date in a range,
    # or the single target date.
    date_str = ARGV.shift
    begin
        start_date = TimmonParser.parse_date(date_str)
    rescue ArgumentError => err
        puts "ERROR: Could not parse entered date (#{date_str})"
            puts err.message
            puts err.backtrace.inspect
        exit 1
    end

    log.info("Entered date: #{start_date}")

    # Parse the date, which is either the first date in a range,
    # or the single target date.
    date_str = ARGV.shift
    if (date_str)
        use_date_range = true
        begin
            end_date = TimmonParser.parse_date(date_str)
        rescue ArgumentError => err
            puts "ERROR: Could not parse entered end date (#{date_str})"
            puts err.message
            puts err.backtrace.inspect
            exit 1
        end
    else
        use_date_range = false
        end_date = nil
    end

    if (use_date_range)
        date_range = (start_date.jd..end_date.jd)
        log.info("Date range: #{date_range}")
    end
    
    log.info("Entered end date: #{end_date}")
  
    log.info("Reading task file #{task_filename}")
    xml_file = File.new(task_filename)

    my_tasks = TaskMap.read_file(xml_file)
    my_tasks.each_key {|key| log.debug(my_tasks[key].to_s)} 

    log.info("Reading activities file #{activities_filename}")
    xml_file = File.new(activities_filename)

    my_activities = ActivityLog.read_file(xml_file)
    my_activities.each_key {|key| log.debug(my_activities[key].to_s)}

    # Go through the list of activities, find all that match the target
    # timeframe, and add the duration to their respective tasks. This
    # adds up a total time value for each task.
    if (my_activities.size > 0)
        my_activities.each_key do |key|
            # Get the activity name and task ID for the activity.
            activity = my_activities[key]
            task_id = activity.task_id
            if (!my_tasks.key?(task_id))
                puts "Task ID #{task_id} not found in task list!"
                next
            end
            add_task = false
            if (use_date_range)
                log.info("Activity jd: #{activity.start.jd}, #{activity.end.jd}.")
                if (date_range === activity.start.jd &&
                    date_range === activity.end.jd)
                    log.info("Activity date in range of target dates:
                        #{start_date.jd}..#{end_date.jd}.")
                    add_task = true
                end
            elsif (activity.start.jd == start_date.jd || 
                    activity.end.jd == start_date.jd)
                log.debug("Activity date matches target date:
                    #{start_date.jd}.")
                add_task = true
            end
            # If the activity matches the target date (or date range),
            # add it to the tasks.
            my_tasks[task_id].add_activity(activity) if (add_task == true)
        end
    end
    
    TimmonParser.print_tasks_csv(my_tasks)
    
    # Create a simple pie chart
    pie_dataset = DefaultPieDataset.new

    day_total_duration = 0
    my_tasks.each_key do |key|
        day_total_duration += my_tasks[key].total_duration
    end

    log.info("Day total duration: #{day_total_duration}")
    
    my_tasks.each_key do |key|
        next if (my_tasks[key].total_duration == 0)
        name = my_tasks[key].name
        duration_percent = (my_tasks[key].total_duration.to_f /
            day_total_duration.to_f) * 100
        log.info("#{name} duration: #{my_tasks[key].total_duration},
            percentage: #{duration_percent.to_i}")
        pie_dataset.setValue(name,
            java.lang.Integer.new(duration_percent))
    end
    
    chart = ChartFactory.createPieChart(
           "Activity breakdown",
            pie_dataset, 
            true, 
            true, 
            false)
    begin
        ChartUtilities.saveChartAsJPEG(java.io.File.new("D:\\Temp\\chart.jpg"), 
          chart, 500, 300)
        image = chart.createBufferedImage(500,300)
        TimmonParser.display_chart(image)
    rescue Exception => e
        puts "Problem occurred creating chart."
        puts e.message
        # puts e.backtrace.inspect
    end
    
end


