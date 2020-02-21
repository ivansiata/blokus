require 'pry'

i = 19
x = 0
board = []
while i >= x do
	j = 19
	y = 0
	z = 0
	while j >= y do
		board << [z,i]
		j -=1
		z += 1
	end
	i -= 1
end

board = []
while i <= 19 do
	while j <= 19 do
		[i,j]
	end
	i -= 1
end

count = 0
board.each_with_index do |b, index|
	if count == 19
		printed = "#{b} \n"
		count = 0
	else
		count += 1
		printed = "#{b} "
	end
	printf "%-9s", printed
end

bloks = {
	l: 	[
				[0,2],
				[0,1],
				[1,0],
				[0,0]
			],
	k: 	[
			  [1,1],
	      [0,1],
	      [1,0],
	      [0,0]
	    ]
}


finished = false

while !finished

	puts "Select board coordinate"
	board_coordinate = gets.chomp.split(",").map(&:to_i)

	puts "Select block type"
	choosen_blok = gets.chomp

	puts "Select blok coordinate"
	blok_coordinate = gets.chomp.split(",").map(&:to_i)

	# insert([2,2], blok, blok[3])
	blok_place = []
	add = [(board_coordinate[0] - blok_coordinate[0]), (board_coordinate[1] - blok_coordinate[1])]
	binding.pry
	bloks[choosen_blok.to_sym].each do |square|
		blok_place << [square[0] + add[0], square[1] + add[1]]
	end

	puts "\n"
	# check valid
	valid = true
	blok_place.each do |bp|
		if !board.include?(bp)
			valid = false
		end
	end

	# placing blok
	if valid
		blok_place.each do |bp|
			board.each_with_index do |b, index|
				if b == bp
					board[index] = ["x"]
				end
			end
		end

		count = 0
		board.each_with_index do |b, index|
			if count == 19
				printed = "#{b} \n"
				count = 0
			else
				printed = "#{b} "
				count += 1
			end
			printf "%-9s", printed
		end

	else
		puts "Not Valid"
	end

end



# def insert(place, choosen_blok, blok)

# end

# [0,2],
# [0,1],
# [1,0],
# [0,0]


# [2,1]
# [1,1]
# [0,0]
# [0,1]