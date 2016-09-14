

module Barbarian
  extend ActiveSupport::Concern


  # RETURNS HOW MUCH EXTRA DAMAGE TAKEN. NEGATIVE IF IT NEGATES DAMAGE
  def barbarian_damage_defense(damage_type)
    if damage_type == 'ms'
      return 2
    elsif damage_type == 'rs'
      return 2
    end
    return 0
  end

  def barbarian_overpower(damage_type)
    if damage_type == 'mp'
      return -2
    end
    return 0
  end

  def barbarian_groundslam
  end

  def barbarian_insight
  end

  def barbarian_whirlwind
  end

  def barbarian_roar
  end

  def barbarian_deathbyaxe
  end

  def barbarian_bezerker
  end

  def barbarian_totem
  end



end
