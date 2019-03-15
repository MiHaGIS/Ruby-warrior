class Player
  attr_reader :hero, :hearts
  def play_turn(warrior)
    @hero = warrior
    @hearts ||= hero.health
    @direction ||= :backward
    @direction = :forward if hero.feel(@direction).wall?
    movement(warrior)
    @hearts = hero.health
  end
  
  def movement(warrior)
    return hero.attack!(@direction) if hero.feel(@direction).enemy?
    return hero.rescue!(@direction) if hero.feel(@direction).captive?
    return hero.walk!(:backward) if near_death? && under_fire?
    return hero.walk! if under_fire?
    return hero.rest! if injured?
    hero.walk!(@direction)
  end

  def injured?
    hero.health < 20
  end

  def under_fire?
    hero.health < hearts
  end
  
  def near_death?
    hero.health < 5
  end
end