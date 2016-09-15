

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

  def barbarian_overpower(damage_type, attack_type)
    attack_bonus = 0
    if damage_type == 'mp'
      return {block: -2, damage_bonus: 0}
    end
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_groundslam(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_insight(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_whirlwind(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_roar(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_deathbyaxe(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_bezerker(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_totem(damage_type, attack_type)
    return {block: 0, damage_bonus: 0}
  end



end
