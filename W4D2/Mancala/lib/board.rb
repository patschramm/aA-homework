class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) { Array.new }
    place_stones
  end

  def place_stones
    @cups.each.with_index do |cup, i|
      if i == 13 || i == 6
        next
      else
        cup.concat([:stone, :stone, :stone, :stone])
      end
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if start_pos < 0 || start_pos > 12
    raise "Starting cup is empty" if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []

    cup_i = start_pos
    while !stones.empty?
      cup_i += 1
      cup_i = 0 if cup_i > 13

      if cup_i == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif cup_i == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[cup_i] << stones.pop
      end
    end

    render
    next_turn(cup_i)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == 6 || ending_cup_idx == 13
      return :prompt
    elsif @cups[ending_cup_idx].length == 1
      return :switch
    else
      return ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? { |cup| cup.empty? } || @cups[7..12].all? { |cup| cup.empty?}
  end

  def winner
    store_1 = @cups[6].count
    store_2 = @cups[13].count

    if store_1 > store_2
      return @name1
    elsif store_2 > store_1
      return @name2
    else
      return :draw
    end
  end
end
