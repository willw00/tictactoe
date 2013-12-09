require 'green_shoes'
require_relative 'tictactoe.rb'

Shoes.app width: 400 do
	@game = Game.new
	@board = flow {"Game Board"}

	def update_board
		@board.append do
			@game.board.each do |row|
				para row
			end
		end
	end
	update_board
	stack do
		button ("Click to play") {
			until @game.finished
			  (@game.current_player == 0) ? @game.player_move : @game.computer_move
			  @game.swap_player
			  update_board
			end
			message = @game.game_over_message
			puts "Game over, " + message
		}
	end
end