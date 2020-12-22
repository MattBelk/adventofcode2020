foods = IO.readlines("Input.txt").map do |line|
	line =~ /(.+)\s\(contains\s(.+)\)/
	{ingredients: $1.split(' '), allergens: $2.split(', ')}
end

allergens = foods.map { |food| food[:allergens] }.flatten.uniq.sort
assigned = allergens.to_h do |allergen|
	possible_foods = foods.select { |food| food[:allergens].include? allergen }
	[allergen, possible_foods.map { |food| food[:ingredients] }.reduce(&:&)]
end

ingredients = foods.map { |food| food[:ingredients] }.flatten
invalid = ingredients - assigned.values.flatten
  
while assigned.values.map(&:length).max > 1
	known = assigned.select { |k,v| v.length == 1 }.values.flatten
	assigned = assigned.to_h { |k,v| [k,  v.length > 1 ? v - known : v] }
end

puts "Part 1: #{ invalid.count }"
puts "Part 2: #{ assigned.keys.sort.map { |allergen| assigned[allergen] }.join(',') }"