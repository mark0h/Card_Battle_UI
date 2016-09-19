
module StatusEffects
  extend ActiveSupport::Concern

  #Called when a card is played
  def apply_status(player_id, status_name)
    current_game_id = session[:game_id]

    status_added = Status.where(name: status_name).first

    new_status_effect = StatusEffect.where(game_id: current_game_id, player_id: player_id, status_id: status_added.id).first_or_create
    new_status_effect.update(remaining: status_added.duration, duration_type: status_added.duration_type)
    logger.info "apply_status new_status_effect: #{new_status_effect.inspect}"
  end

  #Called after an attack or after a round
  def remove_status?(player_id, action)
    stats_to_remove = StatusEffect.where(game_id: session[:game_id], player_id: player_id, duration_type: action)
    logger.info "remove_status? removing: #{stats_to_remove.inspect}"
    stats_to_remove.destroy_all
  end

  #Called after initial damage is calculated.
  #     THIS IS RESPONSIBLE FOR UPDATED DATABASE
  def calculate_effect_damage(current_game, player_id, damage_to_apply, damage_to_receive)
    player_health = current_game.p1_health
    opponent_health = current_game.p2_health

    player_added_damage = 0
    opponent_added_damage = 0

    StatusEffect.where(game_id: current_game.id, player_id: player_id).each do |status_effect|
      status = Status.find(status_effect.status_id)
      added_damage = send("#{status.bonus_method}", 'damage')
      player_added_damage += added_damage[:player].to_i
      opponent_added_damage += added_damage[:opponent].to_i
    end

    player_added_damage = 0 if player_added_damage < 0
    opponent_added_damage = 0 if opponent_added_damage < 0

    player_remaining_health = player_health - (damage_to_receive + player_added_damage)
    opponent_remaining_health = opponent_health - (damage_to_apply + opponent_added_damage)

    current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)
    return (damage_to_receive + player_added_damage), (damage_to_apply + opponent_added_damage)
  end

  #Called to update energy
  #     THIS ONLY RETURNS THE ACTUAL ENERGY COST
  def calculate_effect_energy(player_id)

    added_energy = 0

    StatusEffect.where(game_id: session[:game_id], player_id: player_id).each do |status_effect|
      status = Status.find(status_effect.status_id)
      added_energy += send("#{status.bonus_method}", 'energy').to_i
    end
    return added_energy
  end

  def return_status_list(player_id)
    statuses = StatusEffect.select("status_id").where(game_id: session[:game_id], player_id: player_id)
    status_list = Status.where(id: statuses)
    return status_list
  end



  def defenseless_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def bleed_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def slow_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def poison_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def fatigue_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def blind_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def burning_debuff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def unstoppable_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def fury_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 2}
    end
  end

  def barrier_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def wall_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def protection_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def insight_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end

  def thorns_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 0}
    end
  end



end
