=begin
 Console Decisionator front-end
=end

require 'decision'


if __FILE__ == $0

    if (ARGV.length == 0)
        puts "\n\tUsage: decisionator <filename>\n"
        exit 1
    end
    
    filename = ARGV[0]
    
    puts "Reading decision file #{filename}"
    
    if (!File.exist?(filename))
        puts "Sorry, file #{filename} does not exist."
        exit 1
    end

    # Get the root logger and set its level to DEBUG. This makes the global
    # level WARN.
    Logger.root.level = Log4r::DEBUG

    # Specify logging output format
    format = PatternFormatter.new(:pattern => "%d [%5l] (%12c) - %m")
    StdoutOutputter.new('console', :formatter => format)
    
    log = Logger.new('decisionator')
    log.add('console')
    
    xml_file = File.new(filename)
    
    my_dec = Decision.read_decision(xml_file)
    log.info(my_dec.to_s)

    if (my_dec.solutions.length == 0)
        log.error("No answers have been specified for this decision")
        exit 2
    end

    best_answer = my_dec.solutions[0]
    my_dec.solutions.each do |solution|
        log.info("Solution #{solution.name}: score=#{'%5d' % solution.score}")
        if (solution.score > best_answer.score)
            best_answer = solution
        end
    end

    puts "Decision: #{my_dec.problem}"
    puts "The best answer is: #{best_answer.name}"
    if (best_answer.score < 0)
        puts "The answer had a score of #{best_answer.score}, which is not very good."
    end
    
    # my_dec = Decision.create_decision(1, 5, "Should I have bacon and eggs or cereal for breakfast?")
    
    # p my_dec
    # puts my_dec.to_s
    # my_dec.add_solution(new Solution("bacon and eggs", new Factor(Factor::CON,
        # 3, "more fat")))
    
end


