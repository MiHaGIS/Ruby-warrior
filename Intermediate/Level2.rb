class Player
	attr_reader :hero, :adjacent

  def play_turn(warrior)
  	@hero = warrior
  	@adjacent = Adjacent.new(hero)
  	return hero.attack!(adjacent.enemy_direction) if adjacent.enemy?
  	return hero.rest! if injured?
    hero.walk!(hero.direction_of_stairs)
  end

  def injured?
  	hero.health < 20
  end
end

class Adjacent
	attr_reader :hero, :directions

	def initialize(warrior)
		@hero = warrior
		@directions = {
			forward: hero.feel(:forward),
  		left: hero.feel(:left),
  		right: hero.feel(:right),
  		backward: hero.feel(:backward)
  	}
  end

  def enemy?
  	directions.any? { |dir, space| space.enemy? }
  end

  def enemy_direction
  	directions.select { |dir, space| space.enemy? }.keys.first
  end

end