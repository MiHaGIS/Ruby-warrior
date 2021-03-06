class Player
  attr_reader :hero, :adjacent, :far, :ahead

  def play_turn(warrior)
    @hero = warrior
    @adjacent = Adjacent.new(hero)
    @far = Far.new(hero)
    @ahead = HeadsUp.new(hero)
    movement!
  end

  def movement!
    return hero.rescue!(adjacent.ticking_direction) if adjacent.ticking?
    return hero.bind!(adjacent.enemy_direction) if adjacent.surrounded?
    return hero.rest! if critical? && adjacent.empty?
    return hero.detonate! if far.multiple_enemies_close?
    return hero.detonate!(ahead.bomb_direction) if ahead.double_trouble?
    return hero.attack!(:forward) if hero.feel(:forward).enemy?
    return hero.walk!(avoid_enemy(far.ticking_direction)) if far.ticking?
    return hero.attack!(adjacent.enemy_direction) if adjacent.enemy?
    return hero.rest! if injured?
    return hero.rescue!(adjacent.captive_direction) if adjacent.captive?
    return hero.walk!(avoid_stairs(far.captive_direction)) if far.captive?
    return hero.walk!(avoid_stairs(far.enemy_direction)) if far.enemy?
    hero.walk!(hero.direction_of_stairs)
  end

  def injured?
    hero.health < 20
  end

  def critical?
    hero.health < 5
  end

  def avoid_stairs(direction)
    return direction unless hero.feel(direction).stairs?
    adjacent.empty_direction
  end

  def avoid_enemy(direction)
    return direction unless hero.feel(direction).enemy?
    adjacent.empty_direction
  end
end

class Adjacent
  attr_reader :hero, :directions

  def initialize(warrior)
    @hero = warrior
    @directions = {
      left: hero.feel(:left),
      right: hero.feel(:right),
      forward: hero.feel(:forward),
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

  def empty?
    directions.all? { |dir, space| !space.enemy? }
  end

  def empty_direction
    directions.select { |dir, space| space.empty? }.keys.first
  end

  def ticking?
    directions.any? { |dir, space| space.ticking? }
  end

  def ticking_direction
    directions.select { |dir, space| space.ticking? }.keys.first
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

  def ticking?
    surroundings.any? { |space| space.ticking? }
  end

  def ticking_direction
    hero.direction_of(surroundings.select { |space| space.ticking? }.first)
  end

  def multiple_enemies_close?
    surroundings.select { |space| space.enemy? && hero.distance_of(space) < 3 }.count > 2
  end
end

class HeadsUp
  attr_reader :hero, :directions

  def initialize(warrior)
    @hero = warrior
    @directions = {
      forward: hero.look(:forward),
      left: hero.look(:left),
      right: hero.look(:right),
      backward: hero.look(:backward)
     }
  end

  def double_trouble?
    directions.any? { |dir, ahead| ahead.first(2).all? { |space| space.enemy? }}
  end

  def bomb_direction
    directions.select { |dir, ahead| ahead.first(2).all? { |space| space.enemy? }}.keys.first
  end

end