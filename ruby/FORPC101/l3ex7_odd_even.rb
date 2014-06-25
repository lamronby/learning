=begin
 Exercise7. Write a Ruby program (p021oddeven.rb) that, when given an array as collection = [12, 23, 456, 123, 4579] it displays for each number, whether it is odd or even.
=end

collection = [12, 23, 456, 123, 4579]

collection.each do |i|
    puts "#{i} is #{((i % 2 == 0) ? "even" : "odd")}"
end
