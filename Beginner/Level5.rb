class Player
  attr_reader :hero, :hearts
  def play_turn(warrior)
    @hero = warrior
    @hearts ||= hero.health
    movement(warrior)
    @hearts = hero.health
  end
  
  def movement(warrior)
    return hero.attack! if hero.feel.enemy?
    return hero.rescue! if hero.feel.captive?
    return hero.walk! if under_fire?
    return hero.rest! if injured?
    hero.walk!
  end

  def injured?
    hero.health < 20
  end

  def under_fire?
    hero.health < hearts
  end
end
  