=begin
 Exercise5. Given a string, let us say that we want to reverse the word order (rather than character order). You can use String.split, which gives you an array of words. The Array class has a reverse method; so you can reverse the array and join to make a new string. Write this program.
=end

print "Enter a multi-word string: "
STDOUT.flush

# sentence = gets.chomp

# words = sentence.split.reverse
# new_sentence =  words.join(" ")
# 
# puts "Reversed string: #{new_sentence}"

new_sentence = gets.chomp.split.reverse.join(" ")

puts "Reversed string: #{new_sentence}"


