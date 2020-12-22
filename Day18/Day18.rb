class Integer
	# Redefine the '-' operator to multiply, has same precedence as '+'
	def -(int)
		self * int
	end

	# Redefine the '/' operator to add, has same precedence as '*' (higher than '+')
	def /(int)
		self + int
	end
end

part1_sum = (IO.readlines("Input.txt").map do |expression|
	eval(expression.tr('*', '-'))
end).sum

part2_sum = (IO.readlines("Input.txt").map do |expression|
	eval(expression.tr('*+', '-/'))
end).sum

puts "Part 1: #{part1_sum}"
puts "Part 2: #{part2_sum}"