require 'rspec'
require_relative '../lib/tictactoe.rb'

# board = 
#	0 | 1 | 2
#	3 | 4 | 5 
#	6 | 7 | 8

pw = {0=>[1,1,0,0,1,0,0,0],
			1=>[0,1,0,0,0,1,0,0],
			2=>[0,1,0,0,0,0,1,1],
			3=>[0,0,1,0,1,0,0,0],
			4=>[1,0,1,0,0,1,0,1],
			5=>[0,0,1,0,0,0,1,0],
			6=>[0,0,0,1,1,0,0,1],
			7=>[0,0,0,1,0,1,0,0],
			8=>[1,0,0,1,0,0,1,0]}

game = Game.new

describe Game do

	context "when starting a new game" do
		it "should have a blank board" do 
			game.board.should == [[0,0,0],[0,0,0],[0,0,0]]
		end
		it "should have a blank move tracker" do							
			game.move_tracker.should == [0,0,0,0,0,0,0,0]
		end
		it "should choose a random player to play first" do  
			[0,1].should include(game.current_player)
		end
	end

	describe "when current_player == 1" do 
		before(:each) do 
			game.current_player = 1
		end
		context "and no moves have been played" do
			before(:all) do 
				game.computer_move
			end
			it "should make an 'O' at position a" do
				game.board.should == [[0,0,0], [0,'o',0],[0,0,0]]
			end
			it "should update move_tracker" do 
				game.move_tracker.should == pw[4].map{|n| -1*n}
			end
		end
		context "and there are 2-in-a-row" do
			before(:each) do
				game.move_tracker = [0,0,0,0,0,0,0,0]
				game.pos_weights = {0 => [1,1,0,0,1,0,0,0],
                    				1 => [0,1,0,0,0,1,0,0],
                    				2 => [0,1,0,0,0,0,1,1],
                    				3 => [0,0,1,0,1,0,0,0],
                    				4 => [1,0,1,0,0,1,0,1],
                    				5 => [0,0,1,0,0,0,1,0],
                    				6 => [0,0,0,1,1,0,0,1],
                    				7 => [0,0,0,1,0,1,0,0],
                    				8 => [1,0,0,1,0,0,1,0]}
			end
			it "should attempt to finish 3-in-a-row" do
				game.board = [['o',0,'x'], [0,'o','x'],[0,0,0]]
				game.update_trackers
				game.computer_move
				game.board.should == [['o',0,'x'], [0,'o','x'],[0,0,'o']]
			end
			it "should attempt to finish 3-in-a-row" do
				game.board = [[0,'x',0], ['x','x',0],[0,'o','o']]
				game.update_trackers
				game.computer_move
				game.board.should == [[0,'x',0], ['x','x',0],['o','o','o']]
			end
			it "should attempt to finish 3-in-a-row" do
				game.board = [['x','o','x'], [0,'o',0],['o',0,'x']]
				game.update_trackers
				game.computer_move
				game.board.should == [['x','o','x'], [0,'o',0],['o','o','x']]
			end
		end
		context "and the player has 2-in-a-row" do
			before(:each) do
				game.move_tracker = [0,0,0,0,0,0,0,0]
				game.pos_weights = {0 => [1,1,0,0,1,0,0,0],
                    				1 => [0,1,0,0,0,1,0,0],
                    				2 => [0,1,0,0,0,0,1,1],
                    				3 => [0,0,1,0,1,0,0,0],
                    				4 => [1,0,1,0,0,1,0,1],
                    				5 => [0,0,1,0,0,0,1,0],
                    				6 => [0,0,0,1,1,0,0,1],
                    				7 => [0,0,0,1,0,1,0,0],
                    				8 => [1,0,0,1,0,0,1,0]}
			end
			it "should block the player's 3-in-a-row" do
				game.board = [['x','o',0], [0,'x',0],[0,0,0]]
				game.update_trackers
				game.computer_move
				game.board.should == [['x','o',0], [0,'x',0],[0,0,'o']]
			end
			it "should block the player's 3-in-a-row" do 
				game.board = [['o',0,0], ['x','x',0],[0,0,'o']]
				game.update_trackers
				game.computer_move
				game.board.should == [['o',0,0], ['x','x','o'],[0,0,'o']]
			end
		end
	end

	describe "when performing array arithmetic" do 
		it "should correctly add arrays of points i and c" do 
			sum = game.add(pw[8], pw[2])
			sum.should == [1,1,0,1,0,0,2,1]
		end
		it "should correctly add arrays of points a and b" do 
			sum = game.add(pw[0], pw[1])
			sum.should == [1,2,0,0,1,1,0,0]
		end
		it "should be able to add arrays of points a, b, and c" do
			sum = game.add(pw[0], pw[1], pw[2])
			sum.should == [1,3,0,0,1,1,1,1]
		end
		it "should be able to add arrays of points a, b, c, and d" do 
			sum = game.add(pw[0], pw[1], pw[2], pw[3])
			sum.should == [1,3,1,0,2,1,1,1]
		end

		it "should correctly subtract array c from i" do 
			diff = game.subtract(pw[8], pw[2])
			diff.should == [1,-1,0,1,0,0,0,-1]
		end
		it "should correctly subtract array b from a" do 
			diff = game.subtract(pw[0], pw[1])
			diff.should == [1,0,0,0,1,-1,0,0]
		end
		it "should be able to subtract arrays b and c from a" do
			diff = game.subtract(pw[0], pw[1], pw[2])
			diff.should == [1,-1,0,0,1,-1,-1,-1]
		end
	end	

end