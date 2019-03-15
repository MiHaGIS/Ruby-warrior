class Player

  def play_turn(warrior)
  	return warrior.attack!(warrior.direction_of_stairs) if warrior.feel(warrior.direction_of_stairs).enemy?
    warrior.walk!(warrior.direction_of_stairs)
  end

end