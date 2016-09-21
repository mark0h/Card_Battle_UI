
module Assassin
  extend ActiveSupport::Concern

  # RETURNS HOW MUCH EXTRA DAMAGE TAKEN. NEGATIVE IF IT NEGATES DAMAGE
  def assassin_damage_defense(damage_type)
    if damage_type == 'ms'
      return {damage: 1, damage_text: "took 2 extra damage from Melee Spell attack"}
    elsif damage_type == 'rs'
      return {damage: 1, damage_text: "took 2 extra damage from Ranged Spell attack"}
    elsif damage_type == 'mp'
      return {damage: 1, damage_text: "took 2 extra damage from Melee Physical attack"}
    elsif damage_type == 'rp'
      return {damage: 1, damage_text: "took 2 extra damage from Ranged Physical attack"}
    end
    return {damage: 0, damage_text: ""}
  end

  def assassin_windslash(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def assassin_rupture(damage_type, attack_type, player_id)
    current_game = Game.find(session[:game_id])
    opponent_id = current_game.opponent_id
    apply_status(opponent_id, 'Bleed')
    return {block: 0, damage_bonus: 0}
  end

  def assassin_fan_of_knives(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def assassin_expose_weakness(damage_type, attack_type, player_id)
    current_game = Game.find(session[:game_id])
    opponent_id = current_game.opponent_id
    apply_status(opponent_id, 'Defenseless')
    return {block: 0, damage_bonus: 0}
  end

  def assassin_poison_needles(damage_type, attack_type, player_id)
    current_game = Game.find(session[:game_id])
    opponent_id = current_game.opponent_id
    apply_status(opponent_id, 'Poison')
    if attack_type == 'defense'
      return {block: 0, damage_bonus: 2}
    end
    return {block: 0, damage_bonus: 0}
  end

  def assassin_shadow_strikes(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def assassin_phaseblade(damage_type, attack_type, player_id)
    current_game = Game.find(session[:game_id])
    opponent_id = current_game.opponent_id
    apply_status(opponent_id, 'Fatigue')
    return {block: 0, damage_bonus: 0}
  end

  def assassin_backstab(damage_type, attack_type, player_id)
    current_game = Game.find(session[:game_id])
    opponent_id = current_game.opponent_id
    apply_status(opponent_id, 'Bleed')
    return {block: 0, damage_bonus: 0}
  end



end
