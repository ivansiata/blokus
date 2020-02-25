require 'pry'

class Blokus

  BLOCKS = {
    l5: {
          "1" => [[0, 1],[0, 2],[1, 0],[1, 1],[2, 0]],
          "2" => [[0, 0],[1, 0],[1, 1],[2, 1],[2, 2]],
          "3" => [[0, 2],[1, 1],[1, 2],[2, 0],[2, 1]],
          "4" => [[0, 0],[0, 1],[1, 1],[1, 2],[2, 2]]
        },
    y: {
          "1" => [[0, 1],[1, 0],[1, 1],[2, 1],[3, 1]],
          "2" => [[0, 0],[0, 1],[0, 2],[0, 3],[1, 1]],
          "3" => [[0, 0],[1, 0],[2, 0],[2, 1],[3, 0]],
          "4" => [[0, 2],[1, 0],[1, 1],[1, 2],[1, 3]],
          "5" => [[0, 0],[0, 1],[0, 2],[0, 3],[1, 2]],
          "6" => [[0, 0],[1, 0],[1, 1],[2, 0],[3, 0]],
          "7" => [[0, 1],[1, 0],[1, 1],[1, 2],[1, 3]],
          "8" => [[0, 1],[1, 1],[2, 0],[2, 1],[3, 1]]

        },
    n: [
          [2,0],
          [3,0],
          [0,1],
          [1,1],
          [2,1]
        ],
    v3: [
          [0,0],
          [1,0],
          [0,1]
        ],
    u: [
          [0,0],
          [1,0],
          [0,1],
          [0,2],
          [1,2],
        ],
    v5: [
          [0,0],
          [1,0],
          [2,0],
          [0,1],
          [0,2]
        ],
    z5: [
          [1,0],
          [2,0],
          [1,1],
          [0,2],
          [1,2]
        ],
    x: [
          [1,0],
          [0,1],
          [1,1],
          [2,1],
          [1,2]
        ],
    t5: [
          [1,0],
          [1,1],
          [0,2],
          [1,2],
          [2,2]
        ],
    w:  [
          [1,0],
          [2,0],
          [0,1],
          [1,1],
          [0,2]
        ],
    p:  [
          [0,0],
          [0,1],
          [1,1],
          [0,2],
          [1,2]
        ],
    f:  [
          [1,0],
          [0,1],
          [1,1],
          [1,2],
          [2,2]
        ],
    o4: [
          [0,0],
          [1,0],
          [1,0],
          [1,1]
        ],
    l4: [
          [2,0],
          [0,1],
          [1,1],
          [2,1]
        ],
    t4: [
          [1,0],
          [0,1],
          [1,1],
          [2,1]
        ],
    z4: [
          [1,0],
          [2,0],
          [0,0],
          [0,1]
        ],
    i1: [
          [0,0],
        ],
    i2: [
          [0,0],
          [0,1],
        ],
    i3: [
          [0,0],
          [0,1],
          [0,2]
        ],
    i4: [
          [0,0],
          [0,1],
          [0,2],
          [0,3]
        ],
    i5: [
          [0,0],
          [0,1],
          [0,2],
          [0,3],
          [0,4]
        ]
  }.freeze

  def run_blokus
    initialize_board(19)
    binding.pry

    print_board(19)
    finished = false
    @turn = 0
    @first_turn = true
    player1 = {
      name: "Player 1",
      symbol: "x",
      bloks: BLOCKS.dup  
    }
    
    player2 = {
      name: "Player 2",
      symbol: "y",
      bloks: BLOCKS.dup  
    }

    player3 = {
      name: "Player 3",
      symbol: "y",
      bloks: BLOCKS.dup  
    }

    player4 = {
      name: "Player 4",
      symbol: "y",
      bloks: BLOCKS.dup  
    }
    while !finished
      if @turn == 0
        @player = player1
      elsif @turn == 1
        @player = player2
      elsif @turn == 2
        @player = player3
      elsif @turn == 3
        @player = player4  
      end  
      @player_bloks = @player[:bloks]
      puts "#{@player[:name]}'s turn"
      print_remaining_bloks
      puts "Select board coordinate"
      board_coordinate = gets.chomp.split(",").map(&:to_i)

      if board_coordinate.count != 2
        puts "Must be in x,y format \n\n"
        next
      end
      board_coordinate = board_coordinate.map(&:to_i)

      puts "Select blok type"
      choosen_blok_type = gets.chomp

      if !@player_bloks.keys.include?(choosen_blok_type.to_sym)
        puts "blok not available"
        next
      end

      printed_bloks = []
      printed_blok_base = @player_bloks[choosen_blok_type.to_sym].values.each do |blok|
        blok_1 = initialize_blok_base
        blok.each_with_index do |s|
          blok_1[s[0]][s[1]] = @player[:symbol]
        end
        printed_bloks << blok_1
      end

      print_blok_base(printed_bloks)

      puts "Select blok"
      choosen_blok_direction = gets.chomp

      choosen_blok = @player_bloks[choosen_blok_type.to_sym][choosen_blok_direction]

      if !@player_bloks.include?(choosen_blok_type.to_sym)
        puts "Blok don't exists \n\n"
        next
      end

      puts "Select blok coordinate"
      blok_coordinate = gets.chomp.split(",").map(&:to_i)
      if blok_coordinate.count != 2
        puts "Must be in x,y format \n\n"
        next
      end
      place_blok(board_coordinate, blok_coordinate, choosen_blok, choosen_blok_type)
      print_board(19)

    end
  end

  def print_remaining_bloks
    puts "Remaining Bloks: #{@player_bloks.keys.join(", ")}"
  end

  def validate_place(board_coordinate, blok, add)
    valid = true
    blok_place = []
    blok.each do |b|
      blok_place << [(b[0] + add[0]), (b[1] + add[1])]
    end 

    check_another_blok = true
    if @first_turn && @turn == 0
      valid = false if !blok_place.include?([0,0])
    end

    blok.each do |b|
      blok_place = [(b[0] + add[0]), (b[1] + add[1])]

      #check if outside board or
      if @board[blok_place[0]] == nil || blok_place[0] < 0 || blok_place[1] < 0
        valid = false
      elsif @board[blok_place[0]][blok_place[1]] == nil || @board[blok_place[0]][blok_place[1]] == @player[:symbol]
        valid = false
      end

      #check if turn > 0
      if !@first_turn
        if check_another_blok
          if @board[blok_place[0] + 1][blok_place[1] + 1] != @player[:symbol] &&
            @board[blok_place[0] + 1][blok_place[1] - 1] != @player[:symbol] &&
            @board[blok_place[0] - 1][blok_place[1] + 1] != @player[:symbol] &&
            @board[blok_place[0] - 1][blok_place[1] - 1] != @player[:symbol]
            valid = false
          else
            valid = true
            check_another_blok = false
          end
        end

        if valid
          if @board[blok_place[0] - 1][blok_place[1]] == @player[:symbol] ||
              @board[blok_place[0]][blok_place[1] + 1] == @player[:symbol] ||
              @board[blok_place[0] + 1][blok_place[1]] == @player[:symbol] ||
              @board[blok_place[0]][blok_place[1] - 1] == @player[:symbol]

              valid = false
          end
        end
      end
    end
    valid
  end

  def place_blok(board_coordinate, blok_coordinate, choosen_blok, choosen_blok_type)
    blok = choosen_blok
    blok_place = []
    add = [(board_coordinate[0] - blok_coordinate[0]), (board_coordinate[1] - blok_coordinate[1])]
    
    if validate_place(board_coordinate, blok, add)
      blok.each_with_index do |b|
        blok_place = [(b[0] + add[0]), (b[1] + add[1])]
        @board[blok_place[0]][blok_place[1]] = @player[:symbol]
      end
      @player_bloks.delete(choosen_blok_type.to_sym)
      if @turn == 4
        @turn = 0
        @first_turn = false
      else
        @turn += 1
      end
      @board = @board.transpose.map{|x| x.reverse}
    else
      puts "Not Valid"
    end
  end

  def initialize_board(board_size)
    i = 0
    x = 0
    @board = []
    count = 0

    while i <= board_size do
      board_row = []
      j = 0
    while j <= board_size do
      board_row << j
      j += 1
      count += 1
    end
      @board << board_row
      i += 1
    end
  end

  def initialize_blok_base
    @blok_base = []
    i = 0
    x = 0
    while i <= 5 do
      blok_base_row = []
      j = 0
      while j <= 5 do
        blok_base_row << j
        j += 1
      end
        @blok_base << blok_base_row
        i += 1
    end
    @blok_base
  end

  def print_board(board_size)
    binding.pry
    printed_board = @board.transpose.reverse
    printed_board.each_with_index do |board_column, index_column|
      board_column.each_with_index do |row, index_row|
        if index_row == board_size
          if row.is_a? Integer
            printf "%-7s", "[#{index_row},#{row}]"
            printf "\n"
          else
            printf "%-7s", "[#{row}]"
            printf "\n"
          end
        else
          if row.is_a? Integer
            printf "%-7s", "[#{index_row},#{row}]"
          else
            printf "%-7s", "[#{row}]"
          end
        end
      end
    end
  end

  def print_blok_base(blok_list)
    blok_list.each_with_index do |printed_blok_base, index|
      puts "#{index + 1}. "
      printed_blok_base.transpose.reverse.each_with_index do |board_column, index_column|
        board_column.each_with_index do |row, index_row|
          if index_row == 5
            if !row.is_a? Integer
              printf "%-3s", row
              printf "\n"
            else
              printf "%-3s", nil
              printf "\n"
            end
          else
            if !row.is_a? Integer
              printf "%-3s", row
            else
              printf "%-3s", nil
            end
          end
        end
      end
    end
  end

end

blokus = Blokus.new
blokus.run_blokus