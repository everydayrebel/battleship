class Game < ActiveRecord::Base
  serialize :boards

  def initialize
    super
    self.boards = Array.new(2) { Array.new(100) }
    self.player_count = 0
    self.player_turn = 1
    generate_boards
  end

  # add a shot to the boards
  def add_board_shot(player, position)
    playerArray = player == 1 ? 1 : 0
    positionValue = (boards[playerArray][position] == 's') ? 'x' : 'o'
    self.boards[playerArray][position] = positionValue
    self.save!
  end

  # return the other players board for display
  def return_enemy_board(player)
    enemyPlayer = player == 1 ? 1 : 0
    boards[enemyPlayer].collect { |element|
      (element == "s") ? nil : element
    }
  end

  # return winner, if exists
  def winner
    ship_hits = [] * 2
    2.times do |i|
      ship_hits[i] = self.boards[i].inject(0) {|count, v|
        v == 's' ? count + 1 : count
      }
    end

    if ship_hits[0] == 0
      return 2  # player 1 has no ships, winner is 2
    elsif ship_hits[1] == 0
      return 1  # player 2 has no ships, winner is 1
    end

    0
  end

  def generate_boards
    ships = [5, 4, 3, 3, 2]

    2.times do |i|
      ships.each_with_index do |length, j|
        loop do
          # orientation 0: horizontal, 1: vertical
          orientation = 0 + Random.rand(2)
          orientation_axis = 0 + Random.rand(10 - length)
          other_axis = 0 + Random.rand(10)

          position = if orientation == 0
            orientation_axis + (10 * other_axis)
          else
            (orientation_axis * 10) + other_axis
          end

          break if add_ship(i, position, orientation, length)
        end
      end
    end
    self.save!
  end

  # add ship
  def add_ship(player_array_index, position, orientation, length)
    orientation_multiplier = (orientation == 0) ? 1 : 10
    ship_end = position + (orientation_multiplier * (length - 1))

    # check for ship overlap
    length.times do |i|
      ship_piece_position = position + (orientation_multiplier * i)
      if boards[player_array_index][ship_piece_position] == 's'
        return false
      end
    end

    # place the ship
    length.times do |i|
      ship_piece_position = position + (i * orientation_multiplier)
      self.boards[player_array_index][ship_piece_position] = 's'
    end

    return true
  end

end
