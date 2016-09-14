module AiAttack
  extend ActiveSupport::Concern

  def ai_attack_card(opponent_class_id)
    card_to_play = ""
    current_game_id = session[:game_id]

    logger.info "Running ai_attack_card: opponent_class_id: #{opponent_class_id}"
    total_energy = Game.find(current_game_id).p2_energy

    card_ids = CardGroup.select("card_id").where(game_id: current_game_id, user_id: 0, current_hand_card: true)

    CardPriority.where(class_id: opponent_class_id, card_id: card_ids).order(priority: :desc).each do |priority_card|
      if total_energy <= priority_card.energy_cost
        if card_to_play == ""
          logger.info "ai_attack_card play card: #{priority_card.inspect}"
          card_to_play = SkillCard.find(priority_card.card_id)
          ai_update_energy(priority_card.energy_cost, current_game_id)

          #Set card to cooldown deck
          cooldown_timer = SkillCard.select("cooldown").find(priority_card.card_id)
          card_used = CardGroup.where(game_id: current_game_id, user_id: 0, card_id: priority_card.card_id).first
          card_used.update(current_hand_card: false, deck_card: false, cooldown_card: false, inplay_card: true)
        end
      end
    end

    return card_to_play

  end

  def ai_update_energy(used_energy, game_id)
    current_game = Game.find(game_id)
    new_energy = current_game.p2_energy - used_energy
    current_game.update(p2_energy: new_energy)
  end

  def update_health(damage, damage_type, class_id)

    logger.info "Opponent took #{damage} damage of type #{damage_type}. They are a class #{class_id}"
  end


  def update_ai_play_hand
    current_game_id = session[:game_id]
    @opponent_hand = CardGroup.where(game_id: current_game_id, user_id: 0, current_hand_card: true)
    logger.info "@opponent_hand: #{@opponent_hand.inspect}"
    render partial: "game/gameplay/opponent_hand",layout: false
  end

end
