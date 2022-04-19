# Functions for gameplay
module Gameplay
  def self.setup
    new_board = GameBoard.new
    puts 'Player 1, what is your name?'
    player1 = Player.creation(gets.chomp)
    puts 'Player 2, what is your name?'
    player2 = Player.creation(gets.chomp)
    puts "Your symbols are:\n#{player1.info}\n#{player2.info}\n\n"
    player1.active = true
    play_game(player1, player2, new_board) until new_board.winner? == true
    win(player1, player2, new_board)
  end

  def self.play_game(user1, user2, active_board)
    current_player = user1.active == true ? user1 : user2
    active_board.display_board
    puts "Choose a row number and l(left), m(middle), or r(right).\nExample Input: 1m = center square.\n\n"
    get_input(current_player, active_board)
    toggle_active_player(user1, user2)
  end

  def self.get_input(player, current_board)
    puts "#{player.name} : #{player.symbol}"
    row_number = validate_row.to_i
    position = validate_position
    return if current_board.update_board(row_number, position, player.symbol) == true

    get_input(player, current_board)
  end

  def self.toggle_active_player(usr1, usr2)
    usr1.active = usr1.active ? false : true
    usr2.active = usr2.active ? false : true
  end

  def self.validate_row
    print 'Row: '
    choice = gets.chomp
    return choice if %w[0 1 2].include?(choice)

    puts 'Please enter 0, 1, or 2.'
    validate_row
  end

  def self.validate_position
    print 'Position: '
    choice = gets.chomp.downcase
    return choice if %w[l m r].include?(choice)

    puts 'Please enter l, m, or r.'
    validate_position
  end

  def self.win(player_a, player_b, winning_board)
    winning_board.display_board
    winner = player_a.active == true ? player_b : player_a
    puts "#{winner.name} wins!!\n\n"
    puts 'Would you like to play again? (y/n)'
    setup if gets.chomp.downcase == 'y'
  end
end

# Object representing the gameboard
class GameBoard
  attr_accessor :board, :held_positions

  def initialize
    @board = Array.new(9, '')
    @held_positions = { X: [], O: [] }
  end

  def display_board
    print " #{board[0]} | #{board[1]} | #{board[2]}".center(11)
    puts '| Row 0'
    puts '-----------|'
    print " #{board[3]} | #{board[4]} | #{board[5]}".center(11)
    puts '| Row 1'
    puts '-----------|'
    print " #{board[6]} | #{board[7]} | #{board[8]}".center(11)
    puts "| Row 2\n\n"
  end

  def update_board(row, pos, symbol)
    positions = { 'l': 0, 'm': 1, 'r': 2 }
    index = positions[pos.to_sym] + (row * 3)
    if board[index] == ''
      board[index] = symbol
      held_positions[symbol.to_sym] << index
      true
    else
      puts 'Space already taken.'
      false
    end
  end

  def winner?
    winning_combos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]
    held_positions.each_value do |arr|
      winning_combos.each do |combo|
        return true if combo.all? { |space| arr.include?(space) }
      end
    end
  end
end

# Object representing each player
class Player
  attr_accessor :name, :symbol, :active

  @@count = 0

  def initialize(name)
    @@count += 1
    @name = name
    @symbol = @@count.even? ? 'O' : 'X'
    @active = false
  end

  def self.creation(name)
    new(name)
  end

  def info
    "#{name} : #{symbol}"
  end
end

puts 'Welcome! Would you like to play a new game of Tic Tac Toe? (y/n)'
Gameplay.setup if gets.chomp.downcase == 'y'
