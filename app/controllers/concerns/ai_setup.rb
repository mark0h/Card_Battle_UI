module AiSetup
  extend ActiveSupport::Concern


  def setup_ai_play_hand

    current_game_id = session[:game_id]

    opponent_class_id = params[:opponent_selected_id].gsub(/_selected/,'').to_i
    logger.info "Running setup_ai_play_hand: opponent_class_id: #{opponent_class_id}"
    total_energy = Game.find(current_game_id).p2_energy

    priority_energy = total_energy - 1
    priority_energy = 1 if priority_energy < 1

    current_hand = CardGroup.where(game_id: current_game_id, user_id: 0, current_hand_card: true)

    in_hand_count = current_hand.length
    logger.info "setup_ai_play_hand: in_hand_count start: #{in_hand_count}"

    CardPriority.where(class_id: opponent_class_id).where("energy_cost <= ?", priority_energy).order(priority: :desc).each do |priority_card|
      if card_to_add = CardGroup.where(game_id: current_game_id, user_id: 0, card_id: priority_card.card_id, deck_card: true).first
        logger.info "setup_ai_play_hand: in_hand_count first loop: #{in_hand_count}"
        if in_hand_count < 3
          logger.info "setup_ai_play_hand: adding to hand: #{card_to_add.inspect}"
          card_to_add.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)
          in_hand_count += 1
        end
      end
    end

    if in_hand_count < 3
      CardGroup.where(game_id: current_game_id, user_id: 0, deck_card: true).each do |extra_card|
        logger.info "setup_ai_play_hand: in_hand_count second loop: #{in_hand_count}"
        if in_hand_count < 3
          extra_card.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)
          logger.info "setup_ai_play_hand: adding to hand extra_card: #{extra_card.inspect}"
          in_hand_count += 1
        end
      end
    end

    @opponent_hand = CardGroup.where(game_id: current_game_id, user_id: 0, current_hand_card: true)
    logger.info "@opponent_hand: #{@opponent_hand.inspect}"
    render partial: "game/gameplay/opponent_hand",layout: false


  end

  def return_ai_cooldown_cards
    CardGroup.where(game_id: current_game_id, user_id: 0, cooldown_card: true, cooldown_remaining: 0).each do |card|
      card.update(current_hand_card: false, deck_card: true, cooldown_card: false, inplay_card: false)
    end
  end


end
