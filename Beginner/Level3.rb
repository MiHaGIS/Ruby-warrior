class Player
  attr_reader :hero
  def play_turn(warrior)
    @hero = warrior
  	movement(warrior)
  end
  
  def movement(warrior)
    return hero.attack! if hero.feel.enemy?
    return hero.rest! if injured
    hero.walk!
  end

  def injured?
    hero.heath < 20
  end
end
  