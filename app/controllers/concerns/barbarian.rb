

module Barbarian
  extend ActiveSupport::Concern


  # RETURNS HOW MUCH EXTRA DAMAGE TAKEN. NEGATIVE IF IT NEGATES DAMAGE
  def barbarian_damage_defense(damage_type)
    if damage_type == 'ms'
      return {damage: 2, damage_text: "took 2 extra damage from Melee Spell attack"}
    elsif damage_type == 'rs'
      return {damage: 2, damage_text: "took 2 extra damage from Ranged Spell attack"}
    end
    return {damage: 0, damage_text: ""}
  end

  def barbarian_overpower(damage_type, attack_type, player_id)

    if damage_type == 'mp' && attack_type == 'defense'
      return {block: -2, damage_bonus: 0, allowed: true}
    end
    return {block: 0, damage_bonus: 0, allowed: false, error_text: 'Overpower can only counter Melee Physical attacks. '}
  end

  def barbarian_groundslam(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_insight(damage_type, attack_type, player_id)
    logger.info "calling apply_status for barbarian_insight: damage_type: #{damage_type}  attack_type: #{attack_type} player_id: #{player_id}"
    apply_status(player_id, 'Insight')
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_whirlwind(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_roar(damage_type, attack_type, player_id)
    apply_status(player_id, 'Fury')
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_deathbyaxe(damage_type, attack_type, player_id)
    apply_status(player_id, 'Unstoppable')
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_bezerker(damage_type, attack_type, player_id)
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_totem(damage_type, attack_type, player_id)
    buffs_added = 0
    Status.where(status_type: 'buff').order("RANDOM()").each do |add_buff|
      if StatusEffect.exists?(game_id: session[:game_id], player_id: player_id, status_id: add_buff.id)
      elsif buffs_added < 2
        apply_status(player_id, add_buff.name)
        buffs_added += 1
      end
    end
    return {block: 0, damage_bonus: 0}
  end

  def barbarian_overpower_use?(attack_type, play_hand_count)
    if attack_type == 'defense'
      return true
    else
      if play_hand_count < 2
        return true
      end
    end

  end

  def barbarian_groundslam_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_insight_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_whirlwind_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_roar_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_deathbyaxe_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_bezerker_use?(attack_type, play_hand_count)
    return true
  end

  def barbarian_totem_use?(attack_type, play_hand_count)
    return true
  end


end
