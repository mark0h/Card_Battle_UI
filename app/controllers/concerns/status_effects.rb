
module StatusEffects
  extend ActiveSupport::Concern

  #Called when a card is played
  def apply_status(player_id, status_name)
    current_game_id = session[:game_id]

    status_added = Status.where(name: status_name).first

    StatusEffect.create(game_id: current_game_id, player_id: player_id, status_id: status_added.id, remaining: status.duration)
  end

  #Called after an attack or after a round
  def remove_status?(player_id, action)
    StatusEffect.where(game_id: session[:game_id], player_id: player_id).each do |status|
      if status.duration_type == action
        status.destroy
      end
    end
  end

  #Called after initial damage is calculated.
  #     THIS IS RESPONSIBLE FOR UPDATED DATABASE
  def calculate_effect_damage(current_game, player_id, damage_to_apply, damage_to_receive)
    player_health = current_game.p1_health
    opponent_health = current_game.p2_health

    player_added_damage = 0
    opponent_added_damage = 0

    StatusEffect.where(game_id: current_game.id, player_id: player_id).each do |status|
      added_damage = send("#{status.bonus_method}", 'damage')
      player_added_damage += added_damage[:player].to_i
      opponent_added_damage += added_damage[:opponent].to_i
    end

    player_added_damage = 0 if player_added_damage < 0
    opponent_added_damage = 0 if opponent_added_damage < 0

    player_remaining_health = player_health - (damage_to_receive + player_added_damage)
    opponent_remaining_health = opponent_health - (damage_to_apply + opponent_added_damage)

    current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)
  end

  #Called to update energy
  #     THIS ONLY RETURNS THE ACTUAL ENERGY COST
  def calculate_effect_energy(current_game, player_id)

    added_energy = 0

    StatusEffect.where(game_id: current_game.id, player_id: player_id).each do |status|
      added_energy += send("#{status.bonus_method}", 'damage').to_i
    end
    return added_energy
  end

  def return_status_list(player_id)
    statuses = StatusEffect.select("status_id").where(game_id: session[:game_id], player_id: player_id)
    status_list = Status.where(id: statuses)
    return status_list
  end



  def defenseless_debuff(damage_or_energy)
  end

  def bleed_debuff(damage_or_energy)
  end

  def slow_debuff(damage_or_energy)
  end

  def poison_debuff(damage_or_energy)
  end

  def fatigue_debuff(damage_or_energy)
  end

  def blind_debuff(damage_or_energy)
  end

  def burning_debuff(damage_or_energy)
  end

  def unstoppable_buff(damage_or_energy)
  end

  def fury_buff(damage_or_energy)
    if damage_or_energy == 'energy'
      return 0
    else
      return {player: 0, opponent: 2}
    end
  end

  def barrier_buff(damage_or_energy)
  end

  def wall_buff(damage_or_energy)
  end

  def protection_buff(damage_or_energy)
  end

  def insight_buff(damage_or_energy)
  end

  def thorns_buff(damage_or_energy)
  end



end
