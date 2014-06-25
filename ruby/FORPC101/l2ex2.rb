=begin
Exercise2. The following program:
arg1="Satish", arg2="Sunil", arg3="Marcos"
puts "#{arg1}, #{arg2}, #{arg3}."

when executed, outputs:

>ruby tmp2.rb
SatishSunilMarcos, Sunil, Marcos.
>Exit code: 0

Why?
=end

arg1="Satish", arg2="Sunil", arg3="Marcos"
arg4="Satish", "Sunil", "Marcos"

puts "#{arg1}, #{arg2}, #{arg3}."
puts "#{arg4}"

# In Ruby x = 10, 20, 30 is the same as x = [10, 20, 30]
# 
# The reason is that assignment returns something. So arg3="Marcos"
# actually returns the string "Marcos" and the comma is a way of listing 
# array items. So starting from the right:
# 
# arg1="Satish", arg2="Sunil", arg3="Marcos"
# 
# We do the first assignment (arg3="Marcos") which gives us
# 
# arg1="Satish", arg2="Sunil", "Marcos"
# 
# We do the second assignment (arg2="Sunil") which gives us
# 
# arg1="Satish", "Sunil", "Marcos"
# 
# And finally we do the last assignment (arg1="Satish", "Sunil", "Marcos")
# 
# Question: arg2="Sunil", "Marcos" Why isn't that interpreted as an Array ?
# Answer: Because it's interpreted as:
# arg1="Satish", (arg2="Sunil"), (arg3="Marcos")
# and not as:
# arg1="Satish", arg2=("Sunil", arg3="Marcos").

