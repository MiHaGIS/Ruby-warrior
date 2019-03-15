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
    return hero.walk!(:backward) if near_death? && under_fire?
    return hero.walk! if under_fire?
    return hero.shoot! if clear_shot? && enemy_ahead?
    return hero.rest! if injured?
    return hero.pivot! if hero.feel.wall?
    hero.walk!
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
  
  def clear_shot?
    !hero.look.any? { |space| space.captive? } 
  end
  
  def enemy_ahead?
    hero.look.any? { |space| space.enemy? }
  end
end