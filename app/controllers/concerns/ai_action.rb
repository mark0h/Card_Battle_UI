module AiAction
  extend ActiveSupport::Concern

  def ai_attack_card(opponent_class_id)
    card_to_play = nil
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)

    total_energy = Game.find(current_game_id).p2_energy
    logger.info "Running ai_attack_card: opponent_class_id: #{opponent_class_id} total_energy: #{total_energy}"

    #GET list of cards currently in hand
    card_ids = CardGroup.select("card_id").where(game_id: current_game_id, user_id: 0, current_hand_card: true)

    CardPriority.where(class_id: opponent_class_id, card_id: card_ids).order(priority: :desc).each do |priority_card|
      if total_energy >= priority_card.energy_cost
        if card_to_play.nil?
          logger.info "ai_attack_card play card to check: #{priority_card.inspect}"
          card_to_play = SkillCard.find(priority_card.card_id)

          if send("#{card_to_play.bonus_method}_use?", 'attack', card_ids.length)
            update_ai_energy(priority_card.energy_cost, current_game_id)
            #Set card to inplay deck
            card_used = CardGroup.where(game_id: current_game_id, user_id: 0, card_id: priority_card.card_id).first
            card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)
          else
            card_to_play = nil
          end

        end
      end
    end

    #Update whose turn information
    current_game.update(whose_turn: 12)  #Update to player 1 defending(2)

    return card_to_play

  end

  def ai_defend_card(player_attack_card_type)
    current_game_id = session[:game_id]
    current_game = Game.find(current_game_id)
    total_energy = Game.find(current_game_id).p2_energy

    card_ids = CardGroup.select("card_id").where(game_id: current_game_id, user_id: 0, current_hand_card: true)
    damage_blocked = 0
    damage_countered = 0
    total_bonus = 0
    defense_card = nil
    ai_skipped = false

    SkillCard.where(id: card_ids).each do |ai_card|
      if total_energy >= ai_card.cost

        if ai_card.card_type = 'defense'
          temp_defense_bonus = send("#{ai_card.bonus_method}", player_attack_card_type, 'defense')
          temp_total_bonus = temp_defense_bonus[:block].to_i + (-1 * temp_defense_bonus[:damage_bonus].to_i)
          if temp_total_bonus < total_bonus #ALWAYS less, since we ALWAYS add to total damage taken!
            total_bonus = temp_total_bonus
            defense_card = ai_card
          end
        end
        
      end

    end

    if defense_card.nil?
      ai_skipped = true
    else
      update_ai_energy(defense_card.cost, current_game_id)
      #Set card to inplay deck
      card_used = CardGroup.where(game_id: current_game_id, user_id: 0, card_id: defense_card.id).first
      card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)
    end

    return {card: defense_card, damage_blocked: damage_blocked, damage_countered: damage_countered, ai_skipped: ai_skipped}

  end

  def update_ai_energy(used_energy, game_id)
    current_game = Game.find(game_id)
    new_energy = current_game.p2_energy - used_energy
    current_game.update(p2_energy: new_energy)
  end

  def update_ai_health(damage, damage_type, class_id)

    logger.info "Opponent took #{damage} damage of type #{damage_type}. They are a class #{class_id}"
  end


  def update_ai_play_hand
    current_game_id = session[:game_id]
    @opponent_hand = CardGroup.where(game_id: current_game_id, user_id: 0, current_hand_card: true)
    logger.info "@opponent_hand: #{@opponent_hand.inspect}"
    render partial: "game/gameplay/opponent_hand",layout: false
  end

end
