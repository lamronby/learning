=begin
 Represents a single activity in a log of time management data.
=end

require 'rexml/document'
require 'log4r'

include Log4r

class Activity

    def initialize(id, task_id, period, *other_args)
        @id = id
        @task_id = task_id

        # The period is expected to be in a format like this:
        #   2008:03:14 10:20:00|2008:03:14 11:57:12
        # Parse the period into a start time and end time. Also replace the
        # colons (:) in the date with slashes so that they can be properly
        # parsed by the Time parser. 
        
        start_period = period[0...19].sub(/(\d{4}):(\d{2}):(\d{2})/, '\1/\2/\3')
        @start = DateTime.parse(start_period)
        end_period = period[20...38].sub(/(\d{4}):(\d{2}):(\d{2})/, '\1/\2/\3')
        @end   = DateTime.parse(end_period)

        # Calculate the duration (in seconds). Break down the DateTime
        # difference into hours, minutes, and seconds, then calculate
        # total seconds.
        date_diff = @end - @start
        hours, mins, secs, ignore_fractions =
            Date::day_fraction_to_time(date_diff)
        @duration = (hours * 60 * 60) + (mins * 60) + secs
        
        # Note
        @note = other_args[0] if (other_args[0])

        # Create a logger
        @log = Logger.new("timmon::task_category")
    end

    def to_s
        " Activity ID #{@id}, start #{@start} end #{@end} duration #{'%6.2f' % (@duration/60)}"
    end
    
    attr_reader :id, :task_id, :start, :end, :duration, :note 
    
end

