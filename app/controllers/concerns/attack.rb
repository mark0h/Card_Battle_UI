

module Attack
  extend ActiveSupport::Concern

  def play_attack_card(attack_card_id, class_selected_id, opponent_selected_id)
    @player_attacking = true
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    player_class = ClassCard.find(class_selected_id)
    opponent_class = ClassCard.find(opponent_selected_id)

    energy_cost_bonus = calculate_effect_energy(current_user.id).to_i


    @attack_error = false
    @round_number = current_game.round

    if attack_card_id.to_i == 0
      #Update whose turn information
      current_game.update(whose_turn: 21)  #Update to player 2 defending(2)
      @damage_taken, @damage_returned = 0

      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    else
      @attack_card = SkillCard.find(attack_card_id)
      #Update card to inplay
      card_used = CardGroup.where(game_id: current_game_id, user_id: current_user.id, card_id: attack_card_id).first
      card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)

      opponent_defense_hash = ai_defend_card(@attack_card.attack_type)  #{card: defense_card, damage_blocked: damage_blocked, damage_countered: damage_countered}
      @opponent_defense_card = opponent_defense_hash[:card]
      @ai_skipped = opponent_defense_hash[:ai_skipped]

      #Update energy
      update_energy(@attack_card.cost, current_game_id, energy_cost_bonus)

      #check if this should remove status
      remove_status?(current_user.id, 'attack')

      #Update whose turn information
      current_game.update(whose_turn: 22)  #Update to player 2 defending(2)
      @damage_taken, @damage_returned = player_apply_damage(current_game, current_user.id, player_class, opponent_class, @attack_card, @opponent_defense_card)

      render partial: "game/gameplay/info_windows/gameplay_middle",layout: false
    end


  end

  def player_apply_damage(current_game, player_id, player_class, opponent_class, attack_card, defense_card)
    player_health = current_game.p1_health
    opponent_health = current_game.p2_health

    opponent_damage_type_taken = attack_card.attack_type

    #Calculate the total damage the player will take
    if defense_card.nil?
      player_total_damage_taken= 0
      player_damage_type_taken = 'x'
      opponent_defense_bonus = {block: 0, damage_bonus: 0}
    else
      player_damage_taken = defense_card.damage
      player_damage_type_taken = defense_card.attack_type
      opponent_defense_bonus = send("#{defense_card.bonus_method}", opponent_damage_type_taken, 'defense', 0)
      player_class_damage_defense = send("#{player_class.name.downcase}_damage_defense", player_damage_type_taken)

      player_total_damage_taken = player_damage_taken.to_i + player_class_damage_defense.to_i + opponent_defense_bonus[:damage_bonus]
    end

    #Calculate the total damage they return to the opponent.
    opponent_damage_taken = attack_card.damage
    player_attack_bonus = send("#{attack_card.bonus_method}", player_damage_type_taken, 'attack', current_user.id)
    opponent_class_damage_defense = send("#{player_class.name.downcase}_damage_defense", opponent_damage_type_taken)

    opponent_total_damage_taken = opponent_damage_taken.to_i + opponent_defense_bonus[:block] + opponent_class_damage_defense.to_i + player_attack_bonus[:damage_bonus]

    player_remaining_health = player_health - player_total_damage_taken
    player_remaining_health = 0 if player_remaining_health < 0

    opponent_remaining_health = opponent_health - opponent_total_damage_taken
    opponent_remaining_health = 0 if opponent_remaining_health < 0

    logger.info "player_apply_damage  player values: player_damage_taken: #{player_damage_taken} player_damage_type_taken: #{player_damage_type_taken} player_attack_bonus: #{player_attack_bonus.inspect} player_class_damage_defense: #{player_class_damage_defense}"
    logger.info "player_apply_damage opponent_values: opponent_damage_taken: #{opponent_damage_taken} opponent_damage_type_taken: #{opponent_damage_type_taken} opponent_defense_bonus: #{opponent_defense_bonus.inspect} opponent_class_damage_defense: #{opponent_class_damage_defense}"

    # current_game.update(p1_health: player_remaining_health, p2_health: opponent_remaining_health)

    return player_total_damage_taken, opponent_total_damage_taken
  end

end
