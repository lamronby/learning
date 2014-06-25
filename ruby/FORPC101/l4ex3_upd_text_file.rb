=begin
 Exercise3. Modify the contents of a plain text file.
=end

text_file = ARGV[0]

puts "Reading in #{text_file}"

if (!File.exist?(text_file))
    puts "File #{text_file} does not exist."
    exit 1
end
    
found_word = false
revised_lines = Array.new
revise_pos = -1
fil = File.open(text_file, 'r+')

while (line = fil.gets) do
    if (line =~ /\sword\s/)
        # Save the position in the file for the start of the line that had
        # 'word' in it.
        revise_pos = fil.pos
        revise_pos -= (line.length+1)
        puts "Found line with word in it at position #{revise_pos}"
        
        line.gsub!("word", "insert word")
        puts "Revised line: #{line}"
        revised_lines << line
        found_word = true
    elsif (found_word)
        revised_lines << line
    end
end

# SEEK_CUR - Seeks to first integer number parameter plus current
#            position
# SEEK_END - Seeks to first integer number parameter plus end of stream 
#            (you probably want a negative value for first integer
#            number parameter)
# SEEK_SET - Seeks to the absolute location given by first integer
#            number parameter
# Seek back to the line that had 'word' in it so the line and all
# subsequent lines can be replaced.
if (found_word)
    puts "Revise position: #{revise_pos}"
    fil.seek(revise_pos, IO::SEEK_SET)
    revised_lines.each {|line| fil.puts(line)}
end

fil.close



