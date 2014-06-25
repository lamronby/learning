=begin
 A collection of tasks. This class also has a class method for loading
 task data from a XML file.
=end

require 'task'
require 'rexml/document'
require 'log4r'

include Log4r

class TaskMap

    # TODO
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
    
    # Read task information from an XML file.
    def self.read_file(file)
        doc = REXML::Document.new(file)
        
        @@log = Logger.new("timmon::task_tree")
        @@log.debug("Reading the file.")

        root = doc.root

        # Parse the set of categories
        tasks = Hash.new
        parent = nil
        @@log.debug("Parsing #{root.elements.size} tasks")
        
        root.elements.each(Task::ROOT_ELEM) do |task_element|
            parse_task(tasks, task_element, parent)
        end

        # Return the parsed tasks.
        tasks
    end

    # Parse a single category. This method is used recursively.
    def self.parse_task(tasks, task_element, parent)
        id = task_element.attributes[Task::ID_ELEM]
        name = (parent) ? parent.name + "." : ''
        name << task_element.elements[Task::NAME_ELEM].text

        if (task_element.elements.index(Task::DESCRIPTION_ELEM) > 0)
            description = task_element.elements[Task::DESCRIPTION_ELEM].text
        end
        
        @@log.debug("Parsing task #{id}, name: #{name}, parent: #{parent}")
        
        # Create a new task.
        task = Task.new(name, id, description, 0, parent)

        # Push the new task onto the collection.
        tasks[task.id] = task
        
        # Now parse any subatsks of the current task.
        task_element.elements.each(Task::ROOT_ELEM) do |subtask_elem|
            parse_task(tasks, subtask_elem, task)
        end
    end
    
    attr_reader :tasks
    
end

