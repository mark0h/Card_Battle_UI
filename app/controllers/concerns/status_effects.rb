
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
  def calculate_effect_damage(current_game, player_id, action, attack_damage, defend_damage, attack_type)
    player_health = current_game.p1_health
    opponent_health = current_game.p2_health

    opponent_id = current_game.opponent_id

    attacker_id = opponent_id
    defender_id = player_id
    attack_text = []
    defend_text = []

    #If the action is attack, set attacker_id to player instead
    if action == 'attack'
      attacker_id = player_id
      defender_id = current_game.opponent_id
    end

    game_statuses = StatusEffect.where(game_id: current_game.id)

    #Get status effects of the attacker first
    StatusEffect.where(game_id: current_game.id, player_id: attacker_id).each do |status_effect|
      status = Status.find(status_effect.status_id)
      added_damage = send("#{status.bonus_method}", 'attack', attack_damage, attack_type)
      attack_damage += added_damage[:attack].to_i
      defend_damage += added_damage[:defend].to_i
      attack_text << added_damage[:attack_text]
      defend_text << added_damage[:defend_text]
    end

    attack_damage = 0 if attack_damage < 0
    defend_damage = 0 if defend_damage < 0

    #Get status effects of defender
    StatusEffect.where(game_id: current_game.id, player_id: defender_id).each do |status_effect|
      status = Status.find(status_effect.status_id)
      added_damage = send("#{status.bonus_method}", 'defend', attack_damage, attack_type)
      attack_damage += added_damage[:attack].to_i
      defend_damage += added_damage[:defend].to_i
      attack_text << added_damage[:attack_text]
      defend_text << added_damage[:defend_text]
    end

    attack_damage = 0 if attack_damage < 0
    defend_damage = 0 if defend_damage < 0

    if action == 'attack'
    player_remaining_health = player_health - defend_damage
    opponent_remaining_health = opponent_health - attack_damage
  else  #If player was defending
    player_remaining_health = player_health - attack_damage
    opponent_remaining_health = opponent_health - defend_damage
  end

    player_remaining_health = 0 if player_remaining_health < 0
    opponent_remaining_health =  0 if opponent_remaining_health < 0

    current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)
    return {attack_damage: attack_damage, defend_damage: defend_damage, attack_text: attack_text, defend_text: defend_text}
  end

  #Called to update energy
  #     THIS ONLY RETURNS THE ACTUAL ENERGY COST
  def calculate_effect_energy(player_id)

    added_energy = 0

    StatusEffect.where(game_id: session[:game_id], player_id: player_id).each do |status_effect|
      status = Status.find(status_effect.status_id)
      added_energy += send("#{status.bonus_method}", 'energy', 0, 'x').to_i
    end
    return added_energy
  end

  def return_status_list(player_id)
    statuses = StatusEffect.select("status_id").where(game_id: session[:game_id], player_id: player_id)
    status_list = Status.where(id: statuses)
    return status_list
  end



  def defenseless_debuff(damage_or_energy, attack_damage, attack_type)  #Take double damage, up to +6
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend'
      extra_dam = attack_damage
      extra_dam = 6 if extra_dam > 6
      return {attack: extra_dam, defend: 0, attack_text: '', defend_text: "Defender takes #{extra_dam} extra damage from Defenseless. "}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def bleed_debuff(damage_or_energy, attack_damage, attack_type)   #Take 4 damage on next attack
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'attack'
      return {attack: 0, defend: 4, attack_text: 'Attacker takes 4 damage from Bleed. ', defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def slow_debuff(damage_or_energy, attack_damage, attack_type)  #Deal 1/2 damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'attack'
      less_dam = 0 - (attack_damage / 2)
      return {attack: less_dam, defend: 0, attack_text: "Attacker deals #{less_dam} less damage from Slow. ", defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def poison_debuff(damage_or_energy, attack_damage, attack_type)  #Take +2 damage when defending
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend'
      return {attack: 2, defend: 0, attack_text: '', defend_text: 'Defender takes +2 damage from Poison'}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def fatigue_debuff(damage_or_energy, attack_damage, attack_type) #Skills cost +1
    if damage_or_energy == 'energy'
      return 1
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def blind_debuff(damage_or_energy, attack_damage, attack_type)   #deal -2 damage when attacking
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'attack'
      return {attack: -2, defend: 0, attack_text: "Attacker deals 2 less damage from Blind. ", defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def burning_debuff(damage_or_energy, attack_damage, attack_type)  #Take 4 damage on next attack
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'attack'
      return {attack: 0, defend: 4, attack_text: 'Attacker takes 4 damage from Burning', defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def unstoppable_buff(damage_or_energy, attack_damage, attack_type)  #Skills cost nothing
    if damage_or_energy == 'energy'
      return -4
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def fury_buff(damage_or_energy, attack_damage, attack_type)  #Deal +2 damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'attack'
      return {attack: 2, defend: 0, attack_text: 'Attack did +2 damage from Fury. ', defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def barrier_buff(damage_or_energy, attack_damage, attack_type)  #take 1?2 magic damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend' && attack_type =~ /S/i
      less_dam = 0 - (attack_damage / 2)
      return {attack: less_dam, defend: 0, attack_text: '', defend_text: "Defender resists #{less_dam} spell damage from Barrier. "}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def wall_buff(damage_or_energy, attack_damage, attack_type)  #Take 1/2 physical damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend' && attack_type =~ /P/i
      less_dam = 0 - (attack_damage / 2)
      return {attack: less_dam, defend: 0, attack_text: '', defend_text: "Defender resists #{less_dam} physical damage from Wall. "}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def protection_buff(damage_or_energy, attack_damage, attack_type)  #Take 1/2 all damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend'
      less_dam = 0 - (attack_damage / 2)
      return {attack: less_dam, defend: 0, attack_text: '', defend_text: "Defender resists #{less_dam} damage from Protection. "}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def insight_buff(damage_or_energy, attack_damage, attack_type)  #No ranged damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend' && attack_type =~ /R/i
      blocked_dam = 0 - attack_damage
      return {attack: blocked_dam, defend: 0}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end

  def thorns_buff(damage_or_energy, attack_damage, attack_type)  #attacker takes +2 damage
    if damage_or_energy == 'energy'
      return 0
    elsif damage_or_energy == 'defend'
      return {attack: 0, defend: 2, attack_text: 'Attacker takes +2 damage from Thorns', defend_text: ''}
    else
      return {attack: 0, defend: 0, attack_text: '', defend_text: ''}
    end
  end



end
