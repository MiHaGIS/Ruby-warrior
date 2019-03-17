class Player
  attr_reader :hero, :adjacent, :far

  def play_turn(warrior)
    @hero = warrior
    @adjacent = Adjacent.new(hero)
    @far = Far.new(hero)
    movement!
  end

  def movement!
    return hero.bind!(adjacent.enemy_direction) if adjacent.surrounded?
    return hero.attack!(adjacent.enemy_direction) if adjacent.enemy?
    return hero.rest! if injured?
    return hero.rescue!(adjacent.captive_direction) if adjacent.captive?
    return hero.walk!(avoid_stairs(far.captive_direction)) if far.captive?
    return hero.walk!(avoid_stairs(far.enemy_direction)) if far.enemy?
    hero.walk!(avoid_stairs(hero.direction_of_stairs))
  end

  def injured?
    hero.health < 20
  end

  def avoid_stairs(direction)
    return direction unless hero.feel(direction).stairs?
    adjacent.empty_direction
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
  
  def surrounded?
    directions.select { |dir, space| space.enemy? }.length > 1
  end

  def enemy_direction
    directions.select { |dir, space| space.enemy? }.keys.first
  end

  def captive?
    directions.any? { |dir, space| space.captive? }
  end

  def captive_direction
    directions.select { |dir, space| space.captive? }.keys.first
  end

  def empty_direction
    directions.select { |dir, space| !space.stairs? }.keys.first
  end

end

class Far
  attr_reader :hero, :surroundings

  def initialize(warrior)
    @hero = warrior
    @surroundings = hero.listen
  end

  def enemy?
    surroundings.any? { |space| space.enemy? }
  end

  def enemy_direction
    hero.direction_of(surroundings.select { |space| space.enemy? }.first)
  end

  def captive?
    surroundings.any? { |space| space.captive? }
  end

  def captive_direction
    hero.direction_of(surroundings.select { |space| space.captive? }.first)
  end

end