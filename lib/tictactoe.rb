require 'pry'

class Game
  attr_accessor :move_tracker, :board, :current_player, :pos_weights


  def initialize()
  	@board = [[0,0,0],[0,0,0],[0,0,0]]
  	@move_tracker = [0,0,0,0,0,0,0,0]
  	@current_player = choose_player
    @pos_weights = {0 => [1,1,0,0,1,0,0,0],
                    1 => [0,1,0,0,0,1,0,0],
                    2 => [0,1,0,0,0,0,1,1],
                    3 => [0,0,1,0,1,0,0,0],
                    4 => [1,0,1,0,0,1,0,1],
                    5 => [0,0,1,0,0,0,1,0],
                    6 => [0,0,0,1,1,0,0,1],
                    7 => [0,0,0,1,0,1,0,0],
                    8 => [1,0,0,1,0,0,1,0]}
  end	

  def choose_player
  	rand(2)
  end

  def computer_move
    #binding.pry
    #if @board == [[0,0,0], [0,0,0],[0,0,0]] 
    #  computer_choose(0) 
    #elsif computer_can_win 
    #  computer_choose(line_finisher(-2))
    #elsif player_can_win
    #  computer_choose(line_finisher(2))
    #else
    computer_choose(minimax)
    #end
  end

  def player_move
    puts "Enter move: #{@pos_weights.keys}"
    pos = gets.chomp.to_i
    if position_empty?(pos)
      @board[pos/3][pos%3] = 'x'
      update_trackers
    else
      puts "Position taken"
      player_move
    end
  end

  def finished
    @move_tracker.include?(3) || @move_tracker.include?(-3) || @pos_weights == {}
  end

  def swap_player
    @current_player = (@current_player.abs - 1).abs
  end

  def draw
    print "#{@move_tracker}\n"
    @board.each {|row| puts "#{row}"}
  end

  def computer_choose(pos)
    if position_empty?(pos)
      @board[pos/3][pos%3] = 'o'
      update_trackers
    end
  end

  def minimax
   test_board = @board.flatten
   test_weights = @pos_weights
   test_tracker = @move_tracker
   best_value = 30
   best_pos = 0

   test_weights.keys.each do |pos|
    test_board[pos] = "o"
    test_tracker = subtract(test_tracker, test_weights[pos])
    test_value = evaluate_position(test_tracker)
    best_value, best_pos = test_value, pos if test_value < best_value
    test_tracker, test_board = @move_tracker, @board.flatten
   end
   best_pos
  end

  def evaluate_position(test_tracker)
    return -30 if test_tracker.include?(3) || test_tracker.include?(-3)
    x2 = test_tracker.count(2)
    x1 = test_tracker.count(1)
    o2 = test_tracker.count(-2)
    o1 = test_tracker.count(-1)
    #binding.pry
    return 3*x2 + x1 - ( 3*o2 + o1 )
  end

  def line_finisher(num)
    winning_line = @move_tracker.index(num)
    @pos_weights.select do |pos, weight| 
      weight[winning_line] == 1
    end.keys[0]
  end

  def computer_can_win
    @move_tracker.include?(-2)
  end

  def player_can_win
    @move_tracker.include?(2)
  end

  def update_trackers
    @pos_weights.keys.each do |pos|
      case @board.flatten[pos] 
      when 'o'
        @move_tracker = subtract(@move_tracker, @pos_weights.delete(pos))
      when 'x'
        @move_tracker = add(@move_tracker, @pos_weights.delete(pos))
      end
    end
  end

  def position_empty?(pos)
    @board.flatten[pos] == 0
  end

  def add(*arrs)
  	arrs.transpose.map{|pair| pair.inject(:+)}
  end

  def subtract(*arrs)
    arrs.transpose.map{|pair| pair.inject(:-)}
  end
end

game = Game.new
until game.finished
  (game.current_player == 0) ? game.player_move : game.computer_move
  game.swap_player
  game.draw
end
game.draw
puts "Game over"