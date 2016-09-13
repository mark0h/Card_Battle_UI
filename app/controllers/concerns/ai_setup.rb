module AiSetup
  extend ActiveSupport::Concern


  def setup_ai_play_hand

    current_game_id = session[:game_id]

    opponent_class_id = params[:opponent_selected_id].gsub(/_selected/,'').to_i
    logger.info "Running setup_ai_play_hand: opponent_class_id: #{opponent_class_id}"
    total_energy = Game.find(current_game_id).p2_energy

    priority_energy = total_energy - 1
    priority_energy = 1 if priority_energy < 1

    in_hand_count = 0

    CardPriority.where(class_id: opponent_class_id).where("energy_cost <= ?", priority_energy).order(priority: :desc).each do |priority_card|
      logger.info "CardPriority value: #{priority_card.inspect}"
      next if in_hand_count > 3
      if card_to_add = CardGroup.where(game_id: current_game_id, user_id: 0, card_id: priority_card.card_id, deck_card: true).first
        card_to_add.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)
        in_hand_count += 1
      end
    end

    if in_hand_count < 3
      CardGroup.where(game_id: current_game_id, user_id: 0, deck_card: true).each do |extra_card|
        next if in_hand_count > 3
        extra_card.update(current_hand_card: true, deck_card: false, cooldown_card: false, inplay_card: false)
      end
    end

    @opponent_hand = CardGroup.where(game_id: current_game_id, user_id: 0, current_hand_card: true)
    logger.info "@opponent_hand: #{@opponent_hand.inspect}"
    render partial: "game/gameplay/opponent_hand",layout: false


  end

  def barbarian_setup
    game_id = session[:game_id]
    game_info = Game.find(game_id)
    energy = game_info.round
    energy = 5 if energy > 5  #CANNOT HAVE MORE THAN 5 energy
    priority_list = []

    #Loop through deck to create card hand
    CardGroup.where(game_id: game_id, user_id: 0, deck_card: true).each do |card|
    end

  end

  def guardian_setup
  end

  def assassin_setup
  end

  def summoner_setup
  end

  def druid_setup
  end

end
